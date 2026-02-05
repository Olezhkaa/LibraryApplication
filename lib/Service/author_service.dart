import 'package:library_application/Model/author.dart';
import 'package:library_application/Repository/author_repository.dart';

class AuthorService {
  
  //Получить всех авторов
  Future<List<Author>> getAllAuthors() async {
    return await AuthorRepository().getAllAuthors();
  }

  //Получить автора по id
  Future<Author> getAuthorById(int authorId) async {
    return await AuthorRepository().getAuthorById(authorId);
  }

  //Получить изображениеа автора
  Future<String> getMainImageAuthor(int authorId) async {
    return await AuthorRepository().getMainImageAuthor(authorId);
  }
}
