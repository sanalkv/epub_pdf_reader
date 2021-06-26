import 'package:epub_reader/core/model/book_details_model.dart';
import 'package:epub_reader/core/services/local_db_service.dart';
import 'package:epub_reader/core/services/locator.dart';
import 'package:stacked/stacked.dart';

class PdfViewModel extends BaseViewModel {
  final _localDBService = locator<LocalDBService>();
  BookDetails _bookDetails;

  PdfViewModel(BookDetails bookDetails) : _bookDetails = bookDetails;

  void updateBook(int page) {
    _bookDetails.lastReadPosition = page.toString();
    _localDBService.update(_bookDetails);
  }
}
