class Book{
  int _id;
  String _title;
  String _author;
  int _genre;
  String _imagePath = "";

  Book(
    this._id,
    this._title,
    this._author,
    this._genre,
    this._imagePath
  );

  int get id => _id;
  String get title => _title;
  String get author => _author;
  int get genre => _genre;
  String get imagePath => _imagePath;

  set title(String newTitle) => _title = newTitle;
  set author(String newAuthor) => _author = newAuthor;
  set genre(int newGenre) => _genre = newGenre;
  set imagePath(String newImagePath) => _imagePath = newImagePath;
}