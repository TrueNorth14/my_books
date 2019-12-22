import 'dart:async';
import 'dart:core';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/BookModel.dart';

class BookModelProvider {
  static const String DB_NAME = "bookModel.db";
  Database db;

  Future open() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "book");
    db = await openDatabase(path, version: 1,
              onCreate: (Database db, int version) async {
                await db.execute(
                  "CREATE TABLE Book (isbn INTEGER PRIMARY KEY, title TEXT, author TEXT," +
                  "coverURL TEXT, description TEXT, publisher TEXT");
              });
  }

  Future<BookModel> insert(BookModel book) async {
    var database = db;
    database.insert("book", book.toMap());
    return book;
  }


  Future<int> delete(int isbn) async {
    var database = db;
    return await database.delete("book",
                   where: "isbn = ?",
                   whereArgs: [isbn]);
  }

  Future<int> update(BookModel book) async {
    var database = db;
    return await database.update("book", book.toMap(),
                  where: "isbn = ?",
                  whereArgs: [book.isbn]);
  }

  Future<BookModel> getBookModel(int isbn) async {
    var database = db;
    List<Map> maps = await database.query("book",
                columns: ["isbn","title","author","coverURL","description","publisher"],
                where: "isbn = ?",
                whereArgs: [isbn]);
    return (maps.length > 0) ? BookModel.fromMap(maps.first) : null; 
  }

  Future close() async {
    var database = db;
    database.close();
  }



}