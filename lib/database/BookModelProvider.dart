import 'dart:async';
import 'dart:core';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/BookModel.dart';

class BookModelProvider {
  static const String DB_NAME = "book_database.db";
  Database db;

  Future open() async {
    print("called open");
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "$DB_NAME");
    db = await openDatabase(path, version: 1,
              onCreate: (Database db, int version) async {
                await db.execute(
                  "CREATE TABLE books (isbn INTEGER PRIMARY KEY, title TEXT, author TEXT," +
                  " published_year INT, published_month INT, published_day INT," +
                  "coverURL TEXT, description TEXT, publisher TEXT");
              });
  }

  Future<List<BookModel>> retrieveBookModels() async {
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) {
      return BookModel(
          maps[i]["isbn"],
          maps[i]["title"],
          maps[i]["author"],
          maps[i]["published_year"],
          maps[i]["published_month"],
          maps[i]["published_day"],
          maps[i]["coverURL"],
          maps[i]["description"],
          maps[i]["publisher"],
      );
    });
  }

  Future<BookModel> insert(BookModel book) async {
    var database = db;
    print("opened");
    database.insert("books", book.toMap());
    print("inserted");
    return book;
  }


  Future<int> delete(BookModel book) async {
    var database = db;
    return await database.delete("books",
                   where: "isbn = ?",
                   whereArgs: [book.isbn]);
  }

  Future<int> update(BookModel book) async {
    var database = db;
    return await database.update("books", book.toMap(),
                  where: "isbn = ?",
                  whereArgs: [book.isbn]);
  }

  Future<BookModel> getBookModel(int isbn) async {
    var database = db;
    List<Map> maps = await database.query("books",
                columns: ["isbn", "title", "author", "published_year", "published_month",
                          "published_day", "coverURL", "description", "publisher"],
                where: "isbn = ?",
                whereArgs: [isbn]);
    return (maps.length > 0) ? BookModel.fromMap(maps.first) : null; 
  }

  Future close() async {
    var database = db;
    database.close();
  }



}