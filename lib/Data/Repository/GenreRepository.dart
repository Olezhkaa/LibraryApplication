import 'package:library_application/Data/Model/Genre.dart';

List<Genre> genreList = [
  Genre(1, 'Романтика'),
  Genre(2, 'Детектив'),
  Genre(3, 'Ужасы'),
];

List<Genre> getAllGenre() {
  return genreList;
}