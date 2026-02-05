import 'package:library_application/Model/book.dart';
import 'package:library_application/Repository/book_repository.dart';

class BookService {

  //Получить полный список книг
  Future<List<Book>> getAllBooks() async{
    return await BookRepository().getAll();
  }

  //Получить полный список книг по поиску
  Future<List<Book>> getSearchBook(String term) async{
    return await BookRepository().getSearchBook(term);
  }

  //Получить книгу по ID
  Future<Book> getBookById(int bookId) async {
    return await BookRepository().getById(bookId);
  }

  
}
