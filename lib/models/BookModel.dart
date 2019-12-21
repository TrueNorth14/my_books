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
    String genre;
    String description;
    String publisher;

    String get publicationDate => "$_publishedMonth/$_publishedDay/$_publishedYear";

    /// Default constructor for manually entering in values         
    BookModel(this.isbn, this.title, this.author, 
              this._publishedMonth, this._publishedDay, this._publishedYear);

    /// Named constructor for initiating with ISBN number
    BookModel.withISBN(this.isbn) {
        initializeWithISBN();
    }

    /* 
       * Dummy method for initializing instance variables with ISBN.
       * To implement this, get data(online) about book using ISBN (preferrably
         another class/method) then simply initialize the instance fields.
       * This method gets called in the withISBN() named constructor.
    */
    dynamic initializeWithISBN() {
        // TODO: Implement this method
    }

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


}