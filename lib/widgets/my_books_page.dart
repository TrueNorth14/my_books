import 'package:flutter/material.dart';
import 'package:my_books/models/BookShelfModel.dart';
import 'package:popup_menu/popup_menu.dart';
import 'book_widget.dart';

class MyBooksPage extends StatefulWidget {
  @override
  MyBooksPageState createState() => MyBooksPageState();
}

class MyBooksPageState extends State<MyBooksPage> {
  static BookShelfModel myBookShelf;
  bool displayAddWidget = false;
  GlobalKey btnKey = GlobalKey();
  String currentSort = "title"; //default orientation is title
  String isbnFromField = "";

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
                      width: 350,
                      //color: Colors.white,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: TextField(
                            onChanged: (String chars) {
                              isbnFromField = chars;
                              //print(isbnFromField);
                            },
                            textInputAction: TextInputAction.go,
                            onSubmitted: (String isbn) {
                              setState(() {
                                displayAddWidget = false;
                              });
                              addBookToView(int.parse(isbn));
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              suffix: GestureDetector(
                                //iconSize: 10,
                                //padding: EdgeInsets.all(0),
                                child: Icon(Icons.done),
                                onTap: () {
                                  setState(() {
                                    displayAddWidget = false;
                                  });
                                  addBookToView(int.parse(isbnFromField));
                                },
                              ),
                              labelText: 'Enter ISBN (yes people still do this)',
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                          ),
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
