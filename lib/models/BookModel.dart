import 'dart:convert';

import 'package:http/http.dart' as http;

class BookModel {
/*
   *  Asynchronous static method that takes in an isbn and
   *  queries googles book api. Returns corresponding BookModel.
   */
  static Future<BookModel> getNewBookFromISBN(int isbn) async {
    // TODO: Catch http get exceptions
    // TODO: Handle cases for when isbn isn't valid
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
    List<String> date;
    try {
      date = jsonData["publishedDate"].split('-');
    } catch (Exception) {
      date = null;  
    }

    return BookModel(isbn,
                     jsonData["title"], 
                     jsonData["authors"].join(','),
                     ((date!=null) ? int.parse(date[0]) : -2000),
                     ((date!=null) ? int.parse(date[1]) : -5),
                     ((date!=null) ? int.parse(date[2]) : -14),
                     jsonData["imageLinks"]["thumbnail"], //coverURL
                     jsonData["description"],
                     jsonData["publisher"]);
  }

  /// Instance fields that may be entered by user manually
  int isbn;

  /// Instance fields that gets fetched automatically
  String title;
  String author;
  int publishedYear;
  int publishedMonth;
  int publishedDay;
  String coverURL;
  String description;
  String publisher;

  /// Default constructor for all values
  BookModel(
      this.isbn,
      this.title,
      this.author,
      this.publishedYear,
      this.publishedMonth,
      this.publishedDay,
      this.coverURL,
      this.description,
      this.publisher);

  /// Constructor from map
  BookModel.fromMap(Map<String, dynamic> map) {
    isbn = map["isbn"];
    title = map["title"];
    author = map["author"];
    publishedYear = map["published_year"];
    publishedMonth = map["published_month"];
    publishedDay = map["published_day"];
    coverURL = map["coverURL"];
    description = map["description"];
    publisher = map["publisher"];
  }
  /// Constructor for manually entering in values
  BookModel.fromUserInput(
    this.isbn,
    this.title,
    this.author,
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

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'isbn': isbn,
      'title': title,
      'author': author,
      'publication_year': publishedYear,
      'publication_month': publishedMonth,
      'publication_day': publishedDay,
      'coverURL': coverURL,
      'description': description,
      'publisher': publisher,
    };
    return map;
  }

  @override
  String toString() {
    return "ISBN: $isbn\n" + "Title: $title\n" + "Author: $author\n";
  }
}
