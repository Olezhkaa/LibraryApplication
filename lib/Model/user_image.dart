class UserImage {
  int id;
  int userId;
  String fileName;
  String contentType;
  String fileData;
  String fileSize;
  String url;
  bool isMain;

  UserImage({
    required this.id,
    required this.userId,
    required this.fileName,
    required this.contentType,
    required this.fileData,
    required this.fileSize,
    required this.url,
    required this.isMain,
  });
}