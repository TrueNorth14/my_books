import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_books/models/BookModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("api call test"),
        ),
        body: Center(
          child: RaisedButton(
            child: Text("Call API test."),
            onPressed: () => getBookModel("9780134689555"),
          ),
        ));
  }
}

/*
   *  Asynchronous function that takes in an isbn string and
   *  queries googles book api. Returns a BookModel.
   * 
   *  Google Books API documentation: https://developers.google.com/books/docs/v1/using
   *  
   */
  Future<BookModel> getBookModel(String isbn) async {
    //TODO: Catch http get exceptions

    String url = 'https://www.googleapis.com/books/v1/volumes?q=isbn:' + isbn;
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
    publishedYear = int.parse(date[0]);
    publishedMonth = int.parse(date[1]);
    publishedDay = int.parse(date[2]);

    //get cover image url from json
    coverURL = jsonData["imageLinks"]["thumbnail"];

    //description
    description = jsonData["description"];

    //publisher
    publisher = jsonData["publisher"];

    myBook = BookModel(int.parse(isbn), title, author, publishedMonth,
        publishedDay, publishedYear, coverURL, description, publisher);

    print(myBook.map);
    return myBook;
  }
