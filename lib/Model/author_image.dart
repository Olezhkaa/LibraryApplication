class AuthorImage {
  int id;
  int authorId;
  String fileName;
  String contentType;
  String fileData;
  String fileSize;
  String url;
  bool isMain;

  AuthorImage({
    required this.id,
    required this.authorId,
    required this.fileName,
    required this.contentType,
    required this.fileData,
    required this.fileSize,
    required this.url,
    required this.isMain,
  });
}