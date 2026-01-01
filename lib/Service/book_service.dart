import 'package:library_application/Model/book.dart';
import 'package:library_application/Repository/book_repository.dart';

class BookService {

  //Получить полный список книг
  Future<List<Book>> getAllBooks() async{
    return await BookRepository().getAll();
  }

  //Получить книгу по ID
  Future<Book> getBookById(int bookId) async {
    return await BookRepository().getById(bookId);
  }

  
}
