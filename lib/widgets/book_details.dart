import 'package:flutter/material.dart';
import 'package:my_books/models/BookModel.dart';
import 'package:my_books/widgets/my_books_page.dart';
import 'my_books_page.dart';


class BookDetails extends StatelessWidget {
  final BookModel book;
  //final BookShelfModel bookShelf;

  BookDetails(this.book);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.black),
        body: SafeArea(
          child: SingleChildScrollView(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              book.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(
                              "By " + book.author,
                              style: TextStyle(fontSize: 15),
                            ),
                            Text((book.publishedYear > 0)
                                ? book.publishedYear.toString()
                                : " "),
                            //Spacer(),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: RaisedButton(
                                color: Colors.black,
                                child: Text("Remove Book",
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                                onPressed: () {
                                  MyBooksPageState.removeBookFromView(
                                      book.isbn);
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    )
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
                child: Text(
                    book?.description ??
                        "No description is available for this book. Don't blame us it's Google's fault.",
                    style: TextStyle(fontSize: 15, wordSpacing: 5)),
              )
            ]),
          ),
        ));
  }
}
