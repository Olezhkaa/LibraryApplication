import 'package:library_application/Data/Model/Book.dart';

List<Book> favouriteBookList = [];

List<Book> getAllFavouriteBook() {
  return favouriteBookList;
}

void addFavouritreBook(Book favouriteBook) {
  favouriteBookList.add(favouriteBook);
}

void deleteFavouriteBook(Book favouriteBook) {
  favouriteBookList.remove(favouriteBook);
}