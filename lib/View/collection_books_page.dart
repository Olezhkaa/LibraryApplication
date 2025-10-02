import 'package:flutter/material.dart';
import 'package:library_application/Data/Model/Book.dart';
import 'package:library_application/Data/Repository/FavouriteBookRepository.dart';
import 'package:library_application/View/current_book_page.dart';

class CollectionBooks extends StatefulWidget {
  const CollectionBooks({super.key});

  @override
  State<CollectionBooks> createState() => _CollectionBooksState();
}

class _CollectionBooksState extends State<CollectionBooks> {
  @override
  Widget build(BuildContext context) {
    return collectionContent();
  }

  Scaffold collectionContent() {
    if (getAllFavouriteBook().isEmpty) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Список пуст",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Добавьте книгу в коллецию",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }
    else {
      return Scaffold(
        body: ReorderableListView(
          padding: const EdgeInsets.all(8),
          children: [
            for (final bookInCollection in getAllFavouriteBook()) 
              InkWell(
                key: Key('${bookInCollection.id}'),
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
                            bookInCollection.imagePath,
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
                                bookInCollection.title,
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
                              Text("Автор: ${bookInCollection.author}"),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              !collectionOrNo(bookInCollection)
                                  ? addFavouritreBook(bookInCollection)
                                  : deleteFavouriteBook(
                                      bookInCollection,
                                    );
                            });
                          },
                          icon: collectionOrNo(bookInCollection)
                              ? Icon(Icons.bookmark)
                              : Icon(Icons.bookmark_add_outlined),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CurrentBook(book: bookInCollection),
                      //builder: (_) => CollectionBooks(),
                    ),
                  );
                },
              )
          ],
          proxyDecorator: (Widget child, int index, Animation<double> animation) {
            return Material(
              color: Colors.transparent,
              elevation: 6,
              borderRadius: BorderRadius.circular(12),
              child: child,
            );
          },
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if(oldIndex < newIndex) {
                newIndex -=1;
              }
              final Book item = getAllFavouriteBook().removeAt(oldIndex);
              getAllFavouriteBook().insert(newIndex, item);
            });
          }),
      );

      
    }
    // return Scaffold(
    //   body: ListView.builder(
    //     padding: const EdgeInsets.all(8),
    //     itemCount: getAllFavouriteBook().length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return InkWell(
    //         child: Card.outlined(
    //           margin: const EdgeInsets.only(bottom: 8.0),
    //           //elevation: 4.0,
    //           color: Theme.of(context).cardColor,
    //           child: Padding(
    //             padding: EdgeInsets.all(8),
    //             child: Row(
    //               children: <Widget>[
    //                 //Icon(Icons.menu_book, size: 40,),
    //                 ClipRRect(
    //                   borderRadius: BorderRadius.circular(10),
    //                   child: Image.network(
    //                     getAllFavouriteBook()[index].imagePath,
    //                     width: 80,
    //                     height: 120,
    //                     fit: BoxFit.cover,
    //                   ),
    //                 ),
    //                 SizedBox(width: 12),
    //                 Expanded(
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: <Widget>[
    //                       Text(
    //                         getAllFavouriteBook()[index].title,
    //                         overflow: TextOverflow.ellipsis,
    //                         softWrap: true,
    //                         maxLines: 3,
    //                         style: TextStyle(
    //                           fontSize: 20,
    //                           height: 1,
    //                           color: Theme.of(context).colorScheme.primary,
    //                         ),
    //                       ),
    //                       SizedBox(height: 8),
    //                       Text("Автор: ${getAllFavouriteBook()[index].author}"),
    //                     ],
    //                   ),
    //                 ),
    //                 IconButton(
    //                   onPressed: () {
    //                     setState(() {
    //                       !collectionOrNo(getAllFavouriteBook()[index])
    //                           ? addFavouritreBook(getAllFavouriteBook()[index])
    //                           : deleteFavouriteBook(
    //                               getAllFavouriteBook()[index],
    //                             );
    //                     });
    //                   },
    //                   icon: collectionOrNo(getAllFavouriteBook()[index])
    //                       ? Icon(Icons.bookmark)
    //                       : Icon(Icons.bookmark_add_outlined),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         onTap: () {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (_) =>
    //                   CurrentBook(book: getAllFavouriteBook()[index]),
    //               //builder: (_) => CollectionBooks(),
    //             ),
    //           );
    //         },
    //       );
    //     },
    //   ),
    // );
  }
}

bool collectionOrNo(Book bookInBookList) {
  for (Book bookInCollection in getAllFavouriteBook()) {
    if (bookInCollection == bookInBookList) {
      return true;
    }
  }
  return false;
}
