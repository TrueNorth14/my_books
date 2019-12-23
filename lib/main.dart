import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_books/models/BookModel.dart';
import 'package:my_books/models/BookShelfModel.dart';
import 'package:my_books/database/BookModelProvider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyBooksPage(),
    );
  }
}

class MyBooksPage extends StatefulWidget {
  @override
  _MyBooksPageState createState() => _MyBooksPageState();
}

class _MyBooksPageState extends State<MyBooksPage> {
  BookShelfModel myBookShelf;

  Future<BookShelfModel> _generateBookShelf() async {
    if (myBookShelf != null) {
      print("bypass");
      return myBookShelf;
    }

    BookShelfModel bookShelf = new BookShelfModel();
    BookModel tempBook;
    print("called");
    List<int> isbns = [
      9781451648539, //
      9781603094221, //
      9781936561698, //
      9781603093828, //
      9781603094283, //
      9781603094542, //
      9781603091008, //
      9780985875138, //
      9788320429800, //
      9780743212342,
      9780134689555,
      //"9781644850497"
    ];

    /// Call this first just in case
    bookShelf.retrieveStoredBooks();

    //bookShelf.addBook(isbns.map((isbn) => getBookModel(isbn)));
    for (int isbn in isbns) {
      tempBook = await BookModel.getNewBookFromISBN(isbn);
      bookShelf.addBook(tempBook);
    }
    tempBook = bookShelf.findBook(9781451648539);
    bookShelf.removeBook(tempBook);

    //bookShelf.books.map((book) => print(book.map));
    myBookShelf = bookShelf;
    return bookShelf;

    //myBookShelf = new BookShelfModel();
    //myBookShelf.retrieveStoredBooks();
    //return myBookShelf;
  }

  _asyncMethod() async {
    _generateBookShelf();
  }

  @override
  void initState() {
    //myBookShelf = await _generateBookShelf();
    super.initState();
    //_asyncMethod();
  }

  @override
  Widget build(BuildContext context) {
    //print(MediaQuery.of(context).size.width);
    //print(MediaQuery.of(context).size.height);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        title: Text("My Books", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        //elevation: 10,
      ),
      body: FutureBuilder(
        future: _generateBookShelf(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return GridView.builder(
                padding: EdgeInsets.all(20),
                itemCount: snapshot.data.books.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 13,
                    crossAxisCount: 3,
                    childAspectRatio: 2 / 3),
                itemBuilder: (BuildContext context, int index) {
                  //print(index);
                  return BookWidget(snapshot.data.books[index]);
                });
          }
        },
      ),
    );
  }
}

class BookWidget extends StatelessWidget {
  final BookModel book;

  BookWidget(this.book);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        //print(MediaQuery.of(context).size.width);
        //print(MediaQuery.of(context).size.height);

        return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetails(book),
          ),
        );
      },
      child: Hero(
        tag: book.title,
        child: Container(
          //height: 100,
          //width: 20,
          //color: Colors.blue,
          //padding: EdgeInsets.only(top: 10),
          //constraints: BoxConstraints(maxHeight: 50, maxWidth: 70),
          //child: (child: Image.network(book.coverURL, fit: BoxFit.fill)),

          /*
          foregroundDecoration: BoxDecoration(
            color: Colors.grey,
            backgroundBlendMode: BlendMode.saturation,
          ),
          */
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
                image: NetworkImage(book.coverURL), fit: BoxFit.fill),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 1, blurRadius: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class BookDetails extends StatelessWidget {
  final BookModel book;

  BookDetails(this.book);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      body: SafeArea(
        child: Column(children: [
          // Padding(
          //   padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          //   child: GestureDetector(
          //     child: Icon(Icons.arrow_back),
          //     onTap: () => Navigator.pop(context),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: book.title,
                  child: Container(
                    height: 172.7,
                    width: 115.1,
                    //color: Colors.blue,
                    //padding: EdgeInsets.only(top: 10),
                    //constraints: BoxConstraints(maxHeight: 50, maxWidth: 70),
                    //child: (child: Image.network(book.coverURL, fit: BoxFit.fill)),
                    /*
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    */
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          //colorFilter: ,
                          image: NetworkImage(book.coverURL),
                          fit: BoxFit.fill),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black38,
                            spreadRadius: 1,
                            blurRadius: 10),
                      ],
                    ),
                  ),
                ),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        book.title,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        book.author,
                        style: TextStyle( fontSize: 15),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
          Divider(
            indent: 20,
            endIndent: 20,
            color: Colors.black45,
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(book?.description ??
                "No description is available for this book. Don't blame us it's Google's fault.",
                style: TextStyle(fontSize: 15, wordSpacing: 5)),
          )
        ]),
      ),
    );
  }
}

/*
class BookList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BookListState();
  }
}

class _BookListState extends State<BookList> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
*/


