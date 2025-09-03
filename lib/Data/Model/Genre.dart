class Genre {
  int _id;
  String _title;

  Genre (
    this._id,
    this._title
  );
  
  int get id => _id;
  String get title => _title;

  set title(String newTitle) => _title = newTitle;
}