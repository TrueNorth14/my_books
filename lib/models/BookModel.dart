class BookModel {
  /// Instance fields that may be entered by user manually
  int isbn;
  String title;
  String author;
  int _publishedMonth;
  int _publishedDay;
  int _publishedYear;

  /// Instance fields that gets fetched automatically
  String coverURL;
  String description;
  String publisher;

  String get publicationDate =>
      "$_publishedMonth/$_publishedDay/$_publishedYear";

  /// Default constructor for all values
  BookModel(
      this.isbn,
      this.title,
      this.author,
      this._publishedMonth,
      this._publishedDay,
      this._publishedYear,
      this.coverURL,
      this.description,
      this.publisher);

  /// Constructor for manually entering in values
  BookModel.fromUserInput(
    this.isbn,
    this.title,
    this.author,
    this._publishedMonth,
    this._publishedDay,
    this._publishedYear,
  );

  /// Equality operator. Two books are equal if ISBN is the same.
  @override
  bool operator ==(other) {
    if (other is BookModel) {
      return isbn == other.isbn;
    }
    return false;
  }

  @override
  int get hashCode => isbn.hashCode;

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }

}
