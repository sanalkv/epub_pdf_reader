enum BookType { pdf, epub }

extension fileExtension on BookType {
  String get extension {
    switch (this) {
      case BookType.epub:
        return 'epub';
      case BookType.pdf:
        return 'pdf';
      default:
        return '';
    }
  }
}
