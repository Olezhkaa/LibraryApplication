import 'package:library_application/Data/Model/Book.dart';

List<Book> bookList = [
  Book(1, 'Влюбленная ведьма', "Анна Джейн", 1,'https://content.img-gorod.ru/pim/products/images/66/78/018ee408-c426-7d43-9507-425555b56678.jpg?width=3056&height=1476&fit=bounds'),
  Book(2, 'Твое сердце будет разбито', "Анна Джейн", 1,  'https://content.img-gorod.ru/pim/products/images/6d/aa/01968837-3408-736e-9b4f-af803df56daa.jpg?width=3056&height=1476&fit=bounds'),
  Book(3, 'По осколкам твоего сердца', "Анна Джейн", 1, 'https://content.img-gorod.ru/pim/products/images/e0/bc/018ee924-8e14-7952-92d0-f5e4dc37e0bc.jpg?width=3056&height=1476&fit=bounds'),
  Book(4, 'Крылья', "Кристина Старк",1, 'https://content.img-gorod.ru/pim/products/images/29/08/018fae55-e382-7dc1-89db-b35543972908.jpg?width=3056&height=1476&fit=bounds'),
  Book(5, 'Убийство в "Восточном экспрессе"', "Агата Кристи",2, 'https://content.img-gorod.ru/pim/products/images/f6/5a/018f5df6-a66e-7012-ac05-dba6a39af65a.jpg?width=3056&height=1476&fit=bounds'),
  Book(6, 'Десять негритят', "Агата Кристи",2, 'https://content.img-gorod.ru/pim/products/images/0c/08/018f5e1e-c8e7-7b42-887a-c4bead940c08.jpg?width=3056&height=1476&fit=bounds'),
  Book(7, 'Вечеринка в Хэллоуин', "Агата Кристи",2, 'https://content.img-gorod.ru/pim/products/images/42/b2/018f5e3b-69b5-755a-8dfb-40e4b46a42b2.jpg?width=3056&height=1476&fit=bounds'),
];

List<Book> getAllBook() {
  return bookList;
}