import 'dart:io';

import 'package:epub_reader/core/model/book_details_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'pdf_viewmodel.dart';

class PdfView extends StatelessWidget {
  final BookDetails bookDetails;
  PdfView({Key key, this.bookDetails}) : super(key: key);
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ViewModelBuilder<PdfViewModel>.reactive(
          viewModelBuilder: () => PdfViewModel(bookDetails),
          onModelReady: (model) => _pdfViewerController.jumpToPage(int.parse(bookDetails.lastReadPosition ?? '0')),
          builder: (_, viewModel, __) => SfPdfViewer.file(
            File(bookDetails.path),
            controller: _pdfViewerController,
            pageSpacing: 5,
            onPageChanged: (pdfDetails) => viewModel.updateBook(pdfDetails.newPageNumber),
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              AlertDialog(
                title: Text(details.error),
                content: Text(details.description),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
