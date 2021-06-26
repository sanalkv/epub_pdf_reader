
class BookDetails {
  String fileExtension;
  int id;
  String title;
  String path;
  String lastReadPosition;
  String coverImage;
  String author;

  BookDetails({
    this.id,
    this.title,
    this.path,
    this.lastReadPosition,
    this.coverImage,
    this.author,
    this.fileExtension,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "path": path,
      "lastreadposition": lastReadPosition,
      "coverimage": coverImage,
      "author": author,
      "fileextension": fileExtension,
    };
  }

  factory BookDetails.fromMap(Map<String, dynamic> json) => BookDetails(
        id: json["id"],
        title: json["title"],
        path: json["path"],
        lastReadPosition: json["lastreadposition"],
        coverImage: json["coverimage"],
        author: json["author"],
        fileExtension: json["fileextension"],
      );
}
