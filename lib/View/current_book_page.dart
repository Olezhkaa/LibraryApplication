import 'package:flutter/material.dart';
import 'package:library_application/Data/Model/Book.dart';
import 'package:library_application/Data/Model/Genre.dart';
import 'package:library_application/Data/Repository/FavouriteBookRepository.dart';
import 'package:library_application/Data/Repository/GenreRepository.dart';

class CurrentBook extends StatefulWidget {
  const CurrentBook({super.key, required this.book});

  final Book book;

  @override
  State<CurrentBook> createState() => _CurrentBookState();
}

class _CurrentBookState extends State<CurrentBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.book.title, style: TextStyle(overflow: TextOverflow.fade),),
      ),
      body: Center(
          child: ListView(
            children: [
              SizedBox(height: 10,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(widget.book.imagePath, height: 400,),
              ),
              SizedBox(height: 8,),
              Center(child: Text(widget.book.title, style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),)),
              SizedBox(height: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SizedBox(width: 50,),
                Column(children: [
                  Text(widget.book.author, style: TextStyle(fontSize: 20),),
                  SizedBox(height: 2,),
                  if(getGenrebyId(widget.book.genre) != null) Text(getGenrebyId(widget.book.genre)!.title, style: TextStyle(fontSize: 20),),
                ],),
                IconButton(
                    onPressed: () {
                      setState(() {
                        !collectionOrNo(widget.book) ? addFavouritreBook(widget.book) : deleteFavouriteBook(widget.book);
                      });
                    },
                    icon: collectionOrNo(widget.book) ? Icon(Icons.bookmark) : Icon(Icons.bookmark_add_outlined),),
              ],),
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(child: SizedBox(width: 40,)),
                      TextSpan(text: widget.book.description, style: TextStyle(fontSize: 18, height: 1.5),)
                    ]
                  ),
                  textAlign: TextAlign.justify,)
                //Text(widget.book.description, style: TextStyle(fontSize: 18, height: 1.5), textAlign: TextAlign.justify,),
              ),
            ]
          ),
        ),
      );
  }
}

Genre? getGenrebyId(int id) {
  for(var genre in getAllGenre()) {
    if(genre.id == id) {
      return genre;
    }
  }
  return null;
}

bool collectionOrNo(Book bookInBookList) {
  for(Book bookInCollection in getAllFavouriteBook()) {
    if(bookInCollection == bookInBookList) {
      return true;
    } 
  }
  return false; 
}
