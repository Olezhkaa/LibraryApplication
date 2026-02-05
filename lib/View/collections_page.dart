import 'package:flutter/material.dart';
import 'package:library_application/Model/collection.dart';
import 'package:library_application/Service/collection_service.dart';
import 'package:library_application/View/collection_books_tab.dart';
import 'package:library_application/View/favorite_tab.dart';

class CollectionsPage extends StatefulWidget {
  final int viewCollectionPage;
  final int userId;
  const CollectionsPage({
    required this.viewCollectionPage,
    required this.userId,
    super.key,
  });

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  late int viewCollectionPage;
  late int userId;

  late List<Collection> listCollection = [];

  bool isLoading = true;

  @override
  void initState() {
    viewCollectionPage = widget.viewCollectionPage;
    userId = widget.userId;
    initDate();

    super.initState();
  }

  Future<void> initDate() async {
    try {
      final collections = await CollectionService().getAllCollection();
      setState(() {
        listCollection = collections;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Ошибка загрузки коллекций: $e');
      setState(() {
        // В случае ошибки создаем заглушку
        listCollection = [Collection(title: 'Ошибка загрузки', id: 0)];

        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: listCollection.length,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: listCollection.isNotEmpty && !isLoading
              ? TabBar(
                  padding: EdgeInsets.zero,
                  isScrollable: true,
                  tabs: listCollection
                      .map((collection) => Tab(text: collection.title))
                      .toList(),
                )
              : null,
        ),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (listCollection.isEmpty) {
      return Center(child: Text("Нет доступных коллекций"));
    }

    return TabBarView(
      children: listCollection.map((collection) {
        return buildTabContent(collection);
      }).toList(),
    );
  }

  Widget buildTabContent(Collection collection) {
    final int collectionId = collection.id;

    if (collectionId == 0) {
      return FavoriteBooks(viewCollectionPage: widget.viewCollectionPage, userId: userId);
    }

    return CollectionBooksTab(viewCollectionPage: widget.viewCollectionPage, userId: userId, collectionId: collectionId);
  }


  
}
