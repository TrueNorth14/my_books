import 'package:flutter/material.dart';
import 'package:my_books/models/BookModel.dart';
import 'book_details.dart';


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
