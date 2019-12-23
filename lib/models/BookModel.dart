import 'dart:convert';

import 'package:http/http.dart' as http;

class BookModel {
/*
   *  Asynchronous static method that takes in an isbn and
   *  queries googles book api. Returns corresponding BookModel.
   */
  static Future<BookModel> getBookModel(int isbn) async {
    //TODO: Catch http get exceptions

    String url = 'https://www.googleapis.com/books/v1/volumes?q=isbn:'+isbn.toString();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    BookModel myBook;
    String title;
    String author;
    int publishedMonth;
    int publishedDay;
    int publishedYear;
    String coverURL;
    String description;
    String publisher;

    var response = await http.get(url, headers: requestHeaders);

    //parse json reponse into dart objects
    var jsonData = jsonDecode(response.body);

    //remove unwanted items from jsonData and only get first from list
    jsonData = jsonData["items"][0]["volumeInfo"];

    title = jsonData["title"];
    author =
        jsonData["authors"].join(', '); //join all authors (seperate by comma)

    //seperate date string into month, day, and year variables
    //date format is YYYY-MM-DD
    List<String> date = jsonData["publishedDate"].split('-');

    /*
  publishedYear = int.parse(date[0]);
  publishedMonth = int.parse(date[1]);
  try {
    publishedDay = int.parse(date[2]);
  } catch (Exception) {
    publishedDay = 5;
  }
  */

    //The date stuff is annoying, no month day or year default to negative values
    try {
      publishedYear = int.parse(date[0]);
      publishedMonth = int.parse(date[1]);
      publishedDay = int.parse(date[2]);
    } catch (Exception) {
      publishedYear ??= -2000;
      publishedMonth ??= -5;
      publishedDay ??= -14;
    }

    //get cover image url from json
    coverURL = jsonData["imageLinks"]["thumbnail"];

    //description
    description = jsonData["description"];

    //publisher
    publisher = jsonData["publisher"];

    myBook = BookModel(isbn, title, author, publishedMonth,
        publishedDay, publishedYear, coverURL, description, publisher);

    print(myBook.toMap());
    return myBook;
  }

  /// Instance fields that may be entered by user manually
  int isbn;
  String title;
  String author;

  /// Instance fields that gets fetched automatically
  String coverURL;
  String description;
  String publisher;

  int publishedMonth, publishedDay, publishedYear;

  /// Default constructor for all values
  BookModel(
      this.isbn,
      this.title,
      this.author,
      this.publishedMonth,
      this.publishedDay,
      this.publishedYear,
      this.coverURL,
      this.description,
      this.publisher);

  BookModel.withNoDate(
      this.isbn,
      this.title,
      this.author,
      this.coverURL,
      this.description,
      this.publisher);

  /// Constructor from map
  BookModel.fromMap(Map<String, dynamic> map) {
    isbn = map["isbn"];
    title = map["title"];
    author = map["author"];
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
    var map = <String, dynamic>{
      'isbn': isbn,
      'title': title,
      'author': author,
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
