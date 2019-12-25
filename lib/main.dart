import 'package:flutter/material.dart';
import 'package:my_books/models/BookModel.dart';
import 'package:my_books/models/BookShelfModel.dart';
import 'package:popup_menu/popup_menu.dart';

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
  static BookShelfModel myBookShelf;
  bool displayAddWidget = false;
  GlobalKey btnKey = GlobalKey();
  String currentSort = "title"; //default orientation is title

  Future<BookShelfModel> _generateBookShelf() async {
    if (myBookShelf != null) {
      print("bypass");
      return myBookShelf;
    }

    myBookShelf = new BookShelfModel();
    print("called");

    //BookShelfModel bookShelf = new BookShelfModel();
    /*
    BookModel tempBook;
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
    */

    /// Call this first just in case
    await myBookShelf.retrieveStoredBooks();
    myBookShelf.sortByTitle(); //default orientation

    /*
    for (int isbn in isbns) {
      tempBook = await BookModel.getNewBookFromISBN(isbn);
      bookShelf.addBook(tempBook);
    }
    */

    //myBookShelf = bookShelf;
    return myBookShelf;
  }

  static void removeBookFromView(int isbn) async {
    await myBookShelf.removeBookWithISBN(isbn);
    //setState(() {});
  }

  void addBookToView(int isbn) async {
    try {
      await myBookShelf.addBookWithIsbn(isbn);
      setState(() {
        if (currentSort == 'title') {
          myBookShelf.sortByTitle();
        } else {
          myBookShelf.sortByAuthor();
        }
      });
    } catch (Exception) {}
    ;
  }

  void sortShelfViewByAuthor() {
    setState(() {
      myBookShelf.sortByAuthor();
    });
  }

  void sortShelfViewByTitle() {
    setState(() {
      myBookShelf.sortByTitle();
    });
  }

  @override
  void initState() {
    //myBookShelf = await _generateBookShelf();
    super.initState();
    //_asyncMethod();
  }

  void onClickMenu(MenuItemProvider item) {}

  void onDismiss() {}

  @override
  Widget build(BuildContext context) {
    //print(MediaQuery.of(context).size.width);
    //print(MediaQuery.of(context).size.height);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  displayAddWidget = true;
                });
              },
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
        // leading: GestureDetector(
        //   child: Icon(
        //     Icons.person,
        //     color: Colors.white,
        //   ),
        //   onTap: () {
        //     sortShelfViewByAuthor();
        //   },
        // ),
        title: Text("My Books", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        //elevation: 10,
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder(
            future: _generateBookShelf(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.data.books.length != 0) {
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
                } else {
                  return Padding(
                      padding: EdgeInsets.fromLTRB(20, 240, 20, 0),
                      child: Text(
                        "There are no books in your collection. " +
                            "Click the add icon in the top right to get started.",
                        textAlign: TextAlign.center,
                      ));
                }
              }
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: MaterialButton(
                  elevation: 10,
                  color: Colors.black,
                  key: btnKey,
                  child: Text(
                    "Sort Books",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    PopupMenu menu = PopupMenu(
                        // backgroundColor: Colors.teal,
                        // lineColor: Colors.tealAccent,
                        // maxColumn: 2,
                        context: context,
                        items: [
                          //MenuItem(title: 'Copy', image: Image.asset('assets/copy.png')),
                          MenuItem(
                            title: 'By Title',
                            // textStyle: TextStyle(fontSize: 10.0, color: Colors.tealAccent),
                            image: Icon(
                              Icons.book,
                              color: Colors.white,
                            ),
                          ),
                          MenuItem(
                              title: 'By Author',
                              image: Icon(
                                Icons.person,
                                color: Colors.white,
                              )),
                        ],
                        onClickMenu: (MenuItemProvider item) {
                          if (item.menuTitle == 'By Title') {
                            currentSort = "title";
                            sortShelfViewByTitle();
                          } else {
                            currentSort = "author";
                            sortShelfViewByAuthor();
                          }
                        },
                        // stateChanged: stateChanged,
                        onDismiss: onDismiss);
                    menu.show(widgetKey: btnKey);
                  },
                )
                // RaisedButton(
                //   color: Colors.black,
                //   onPressed: () => setState(() {
                //     displayAddWidget = true;
                //   }),
                //   child: Text(
                //     "Add a book",
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
                ),
          ),
          (displayAddWidget)
              ? Stack(children: [
                  Opacity(
                    opacity: .20,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          displayAddWidget = false;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 150,
                      width: 300,
                      color: Colors.white,
                      //decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextField(
                          onSubmitted: (String isbn) {
                            setState(() {
                              displayAddWidget = false;
                            });
                            addBookToView(int.parse(isbn));
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Enter ISBN'),
                        ),
                      ),
                    ),
                  )
                ])
              : Container() //empty container contains no child
        ],
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
          //duration: Duration(seconds: 10),
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
                                  _MyBooksPageState.removeBookFromView(
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
