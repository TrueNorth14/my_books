import 'BookModel.dart';

class BookShelfModel extends Iterable<BookModel> {
  /// The list that keeps track of all the books
  List<BookModel> _books = [];

  @override
  Iterator<BookModel> get iterator => new _BookShelfIterator(_books);

  List<BookModel> get books => _books;

  /// Method to find book using isbn
  BookModel findBook(int isbn) {
    for (BookModel book in _books) {
      if (book.isbn == isbn) return book;
    }
    return null;
  }

  /// Method to add book to list
  void addBook(BookModel book) => _books.add(book);

  /// Method to remove book from list
  void removeBook(int isbn) {
    _books.remove(findBook(isbn));
  }

  /* 
       * Dummy method for sorting the books by author.
    */
  void sortByAuthor() {
    // TODO: IMPLEMENT
  }

  /* 
       * Dummy method for sorting the books by title.
    */
  void sortByTitle() {
    // TODO: IMPLEMENT
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
