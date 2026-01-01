import 'package:library_application/Model/genre.dart';
import 'package:library_application/Repository/genre_repository.dart';

class GenreService {
  //Получить полный список жанров
  Future<List<Genre>> getAllGenres() async {
    return await GenreRepository().getAll();
  }
}
