class FavoriteBook
{
    int id;
    int userId;
    int bookId;
    int priorityInList;

    FavoriteBook({
      required this.id,
      required this.userId,
      required this.bookId,
      required this.priorityInList,
    });
}