import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_application/Model/book.dart';
import 'package:library_application/Service/book_service.dart';
import 'package:library_application/Service/collection_book_service.dart';
import 'package:library_application/View/current_book_page.dart';

class CollectionBooksTab extends StatefulWidget {
  final int viewCollectionPage;
  final int userId;
  final int collectionId;
  const CollectionBooksTab({required this.viewCollectionPage, required this.userId, required this.collectionId, super.key});

  @override
  State<CollectionBooksTab> createState() => _CollectionBooksState();
}

class _CollectionBooksState extends State<CollectionBooksTab> {
  late int viewCollectionPage;
  late int userId;
  late int collectionId;

  bool isLoading = true;

  List<Book> listCollectionBooks = [];

  @override
  void initState() {
    viewCollectionPage = widget.viewCollectionPage;
    userId = widget.userId;
    collectionId = widget.collectionId;

    initData();

    super.initState();
  }

  Future<void> initData() async {
    var collectionBookList = await CollectionBookService().getAllBookInCollectionByUser(userId, collectionId);

    //Загружаем книги
    if(collectionBookList.isNotEmpty) {
      for(final collectionBook in collectionBookList) {
        try {
          Book book = await BookService().getBookById(collectionBook.bookId);
          listCollectionBooks.add(book);
        } catch (e) {
          debugPrint('Не удалось загрузить книгу ${collectionBook.bookId}: $e');
        }
      }
    }

    setState(() => isLoading=false);
  }


  @override
  Widget build(BuildContext context) {
    if(isLoading && listCollectionBooks.isNotEmpty) return Center(child: CircularProgressIndicator(),);
    if(!isLoading && listCollectionBooks.isEmpty) {
      return Center(child: Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [Text("Список пуст", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),  Text("Добавьте книгу в коллекцию", style: TextStyle(fontSize: 16),)],),
    ));
    }
    else if (widget.viewCollectionPage == 1) {
      return Scaffold(
        body: GridView.builder(
          padding: EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 2,
              mainAxisExtent: 340,),
          itemCount: listCollectionBooks.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                  key: ValueKey(listCollectionBooks[index].id),
                  child: Card.outlined(
                    margin: EdgeInsets.zero,
                    shape: null,
                    shadowColor: Colors.transparent,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                listCollectionBooks[index].imagePath,
                                width: 160,
                                height: 260,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            listCollectionBooks[index].title,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Expanded(child: Text("Автор: ${listCollectionBooks[index].author}")),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CurrentBook(book: listCollectionBooks[index], userId: userId,),
                      ),
                    );
                  },
                );
          },
      )
            );
    }
    else {
      return Scaffold(
        body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: listCollectionBooks.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                key: Key('${listCollectionBooks[index].id}'),
                child: Card.outlined(
                  margin: EdgeInsets.only(bottom: 8),
                  //elevation: 4.0,
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: <Widget>[
                        //Icon(Icons.menu_book, size: 40,),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            listCollectionBooks[index].imagePath,
                            width: 80,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                listCollectionBooks[index].title,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 3,
                                style: TextStyle(
                                  fontSize: 20,
                                  height: 1,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text("Автор: ${listCollectionBooks[index].author}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CurrentBook(book: listCollectionBooks[index], userId: userId,),
                    ),
                  );
                },
              );
          },
        ),
      );
    }
  }

}