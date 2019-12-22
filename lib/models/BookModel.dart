import 'dart:convert';

import 'package:http/http.dart' as http;

class BookModel {
/*
   *  Asynchronous static method that takes in an isbn and
   *  queries googles book api. Returns corresponding BookModel.
   */
  static Future<BookModel> getNewBookFromISBN(int isbn) async {
    // TODO: Catch http get exceptions
    String url = 'https://www.googleapis.com/books/v1/volumes?q=isbn:'+isbn.toString();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var response = await http.get(url, headers: requestHeaders);

    //parse json reponse into dart objects
    var jsonData = jsonDecode(response.body);
    //remove unwanted items from jsonData and only get first from list
    jsonData = jsonData["items"][0]["volumeInfo"];

    //seperate date string into month, day, and year variables
    //date format is YYYY-MM-DD
    List<String> date = jsonData["publishedDate"].split('-');

    return BookModel(isbn,
                     jsonData["title"], 
                     jsonData["authors"].join(','),
                     int.parse(date[0]), // published month
                     int.parse(date[1]), // published day
                     int.parse(date[2]), // published year
                     jsonData["imageLinks"]["thumbnail"], //coverURL
                     jsonData["description"],
                     jsonData["publisher"]);
  }

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
    return "ISBN: $isbn\n"+
           "Title: $title\n"+
           "Author: $author\n";
  }

}

void main() {
  var x = new BookModel(13, "a", "a", 1, 1, 1, "a", "a", "a");
  print(x.toString());
}