import 'dart:convert';
import 'dart:io';

import 'package:epub_reader/app/app.router.dart';
import 'package:epub_reader/core/enum/book_type.dart';
import 'package:epub_reader/core/enum/busy_objects.dart';
import 'package:epub_reader/core/services/locator.dart';
import 'package:epub_reader/core/services/url_launcher_service.dart';
import 'package:epub_viewer/epub_viewer.dart';
import 'package:epubx/epubx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_text/pdf_text.dart' hide PDFPage;
import 'package:pdf_viewer_jk/pdf_viewer_jk.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../core/model/book_details_model.dart';
import '../../../core/services/local_db_service.dart';
import 'package:image/image.dart' as image;

enum BusyObject { isDownloading }

class HomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _localDBService = locator<LocalDBService>();
  final _urlLauncherService = locator<UrlLauncherService>();

  List<BookDetails> _allBooks = [];

  int get newlyAddedBookIndex => allBooks.length - 1;
  List<BookDetails> get allBooks => _allBooks;

  /* -------------------------------------- Public Functions -------------------------------------- */

  Future init() async {
    setBusy(true);
    _initialiseEpub();
    await _getBooks();
    setBusy(false);
  }

  Future<bool> pickAndSaveBook() async {
    bool _didBookSave = false;
    setBusyForObject(BusyObjects.addBook, true);
    final filePickerResult = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['epub', 'pdf']);
    if (filePickerResult != null && filePickerResult.files.isNotEmpty) _didBookSave = await _saveBookContent(filePickerResult.files[0]);
    setBusyForObject(BusyObjects.addBook, false);
    return _didBookSave;
  }

  void openBook(BookDetails bookDetails) async {
    setBusyForObject(BusyObjects.openBook, true);
    if (bookDetails.fileExtension == BookType.epub.extension)
      _openEpub(bookDetails);
    else if (bookDetails.fileExtension == BookType.pdf.extension) _openPDF(bookDetails);
  }

  Future deleteBook(BookDetails bookDetails) async {
    await _deleteBook(bookDetails);
    await _getBooks();
    notifyListeners();
  }
  
  /* -------------------------------------- Private Functions ------------------------------------- */

  void _initialiseEpub() {
    EpubViewer.setConfig(
      themeColor: Colors.brown[300],
      scrollDirection: EpubScrollDirection.HORIZONTAL,
      allowSharing: true,
      enableTts: true,
    );
  }

  void _openEpub(BookDetails bookDetails) {
    EpubViewer.open(
      bookDetails.path,
      lastLocation: bookDetails.lastReadPosition != null ? EpubLocator.fromJson(json.decode(bookDetails.lastReadPosition)) : null,
    );
    EpubViewer.locatorStream.listen((locator) async {
      bookDetails.lastReadPosition = locator;
      await _updateBooks(bookDetails);
      await _getBooks();
      setBusyForObject(BusyObjects.openBook, false);
    }, onError: (e) {
      print(e);
    });
  }

  _openPDF(BookDetails bookDetails) async {
    await _navigationService.navigateTo(Routes.pdfView, arguments: PdfViewArguments(bookDetails: bookDetails));
    await _getBooks();
    setBusyForObject(BusyObjects.openBook, false);
  }

  Future<bool> _saveBookContent(PlatformFile file) async {
    bool _didBookSave = false;
    if (file.extension == BookType.epub.extension) {
      final bookDetails = await _saveEpubContent(file.path);
      if (bookDetails != null) {
        await _addNewBook(bookDetails);
        await _getBooks();
        _didBookSave = true;
      } else {
        _snackbarService.showSnackbar(
          duration: Duration(seconds: 5),
          message: 'Epub Failed to Load. Please select another epub or contact customer support',
          mainButtonTitle: 'Support',
          onMainButtonTapped: () => openEmail(),
        );
        _didBookSave = false;
      }
    } else if (file.extension == BookType.pdf.extension) {
      final bookDetails = await _savePDFContent(file.path);
      if (bookDetails != null) {
        await _addNewBook(bookDetails);
        await _getBooks();
        _didBookSave = true;
      } else
        _didBookSave = false;
    }
    return _didBookSave;
  }

  Future<BookDetails> _savePDFContent(String localFilePath) async {
    try {
      BookDetails bookDetails = BookDetails();
      final _pdfDoc = await PDFDoc.fromPath(localFilePath);
      final document = await PDFDocument.fromFile(File(localFilePath));
      PDFPage pageOne = await document.get(page: 1);
      if (pageOne.imgPath != null && pageOne.imgPath.isNotEmpty) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/${DateTime.now().toIso8601String()}';
        final file = File(pageOne.imgPath);
        await file.copy(filePath);
        bookDetails.coverImage = filePath;
      }
      if (_pdfDoc.info.authors == null || _pdfDoc.info.authors.isEmpty)
        bookDetails.author = '';
      else
        bookDetails.author = _pdfDoc.info.authors.join(',');
      if (_pdfDoc.info.title == null || _pdfDoc.info.title.isEmpty)
        bookDetails.title = 'PDF';
      else
        bookDetails.title = _pdfDoc.info.title;
      bookDetails.fileExtension = BookType.pdf.extension;
      bookDetails.path = localFilePath;
      return bookDetails;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<BookDetails> _saveEpubContent(String localFilePath) async {
    try {
      BookDetails bookDetails = BookDetails();
      var targetFile = File(localFilePath);
      List<int> bytes = await targetFile.readAsBytes();
      EpubBook epubBook = await EpubReader.readBook(bytes);
      if (epubBook.CoverImage != null) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/${DateTime.now().toIso8601String()}';
        final file = File(filePath);
        await file.writeAsBytes(
          image.encodePng(epubBook.CoverImage),
        );
        bookDetails.coverImage = filePath;
      }
      if (epubBook.Author == null || epubBook.Author.isEmpty)
        bookDetails.author = '';
      else
        bookDetails.author = epubBook.Author;
      if (epubBook.Title == null || epubBook.Title.isEmpty)
        bookDetails.title = 'EPUB';
      else
        bookDetails.title = epubBook.Title;
      bookDetails.fileExtension = BookType.epub.extension;
      bookDetails.path = localFilePath;
      return bookDetails;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /* -------------------------------------- Local DB Service ------------------------------------- */

  Future<List<BookDetails>> _getBooks() async => _allBooks = await _localDBService.getBooks();

  Future _addNewBook(BookDetails bookDetails) async => await _localDBService.add(bookDetails);

  Future _updateBooks(BookDetails bookDetails) async => await _localDBService.update(bookDetails);

  Future _deleteBook(BookDetails bookDetails) async => await _localDBService.delete(bookDetails);

  /* -------------------------------------- Url Launcher Service ------------------------------------- */

  void openEmail() => _urlLauncherService.launchEmailApp();
}
