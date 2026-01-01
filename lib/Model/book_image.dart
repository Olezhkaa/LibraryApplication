class Bookimage {
  int id;
  int bookId;
  String fileName;
  String contentType;
  String fileData;
  String fileSize;
  String url;
  bool isMain;

  Bookimage({
    required this.id,
    required this.bookId,
    required this.fileName,
    required this.contentType,
    required this.fileData,
    required this.fileSize,
    required this.url,
    required this.isMain,
  });
}
