import 'package:my_books/models/BookModel.dart';

class BookShelfModel extends Iterable<BookModel> {

    /// The list that keeps track of all the books
    List<BookModel> _books = [];

    @override
    Iterator<BookModel> get iterator => new _BookShelfIterator(_books);

    void addBook(BookModel book) => _books.add(book);

    BookModel removeBook(int isbn) {
        for (BookModel book in _books) {
            if (book.isbn == isbn) {
                _books.remove(book);
                break;
            }
        }
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
        return  ++_currIndex < _books.length;
    }
    
}
