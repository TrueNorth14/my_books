import 'BookModel.dart';
import 'package:my_books/database/BookModelProvider.dart';

class BookShelfModel extends Iterable<BookModel> {
  /// The list that keeps track of all the books
  List<BookModel> _books = [];

  BookModelProvider bookModelProvider = new BookModelProvider();

  @override
  Iterator<BookModel> get iterator => new _BookShelfIterator(_books);

  List<BookModel> get books => _books;

  /// Calls the database and fills up the books list
  dynamic retrieveStoredBooks() async {
      await bookModelProvider.open();
      _books = await bookModelProvider.retrieveBookModels();
      await bookModelProvider.close();
  }

  /// Method to find book using isbn
  BookModel findBook(int isbn) {
    for (BookModel book in _books) {
      if (book.isbn == isbn) return book;
    }
    return null;
  }

  /// Method to add book to list
  void addBook(BookModel book) async {
    _books.add(book);
    print("added to shelf");
    await bookModelProvider.open();
    print("opened");
    await bookModelProvider.insert(book);
    await bookModelProvider.close();
  } 

  void removeBook(BookModel book) {
      _books.remove(book);
      bookModelProvider.open();
      bookModelProvider.delete(book);
      bookModelProvider.close();
  }

  /// Method to remove book from list with isbn
  void removeBookWithISBN(int isbn) {
    removeBook(findBook(isbn));
  }

  void sortByAuthor() {
    _books.sort((a,b) => a.author.compareTo(b.author));
  }

  void sortByTitle() {
    _books.sort((a,b) => a.title.compareTo(b.title));
  }
}

class _BookShelfIterator extends Iterator<BookModel> {
  /// Just a regular schmegular Iterator, why no nested classes (?)
  List<BookModel> _books = [];
  int _currIndex = 0;

  /// Default constructor, must pass in the original _books list
  _BookShelfIterator(List<BookModel> _books) {
    this._books = _books;
  }

  @override
  BookModel get current => _books[_currIndex];

  @override
  bool moveNext() {
    return ++_currIndex < _books.length;
  }
}
