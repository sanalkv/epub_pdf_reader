import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/book_details_model.dart';

class LocalDBService {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'bookdetail.db');
    var db = await openDatabase(path, version: 2, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE bookdetail(id INTEGER PRIMARY KEY, title TEXT, path TEXT, lastreadposition TEXT, coverimage TEXT, author TEXT,fileextension TEXT)');
  }

  Future<BookDetails> add(BookDetails bookDetails) async {
    var dbClient = await db;
    bookDetails.id = await dbClient.insert('bookdetail', bookDetails.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return bookDetails;
  }

  Future<List<BookDetails>> getBooks() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('bookdetail', columns: ['id', 'title', 'path', 'lastreadposition', 'coverimage', 'author','fileextension']);
    List<BookDetails> bookDetails = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        bookDetails.add(BookDetails.fromMap(maps[i]));
      }
    }
    return bookDetails;
  }

  Future<int> delete(BookDetails bookDetails) async {
    var dbClient = await db;
    return await dbClient.delete(
      'bookdetail',
      where: 'id = ?',
      whereArgs: [bookDetails.id],
    );
  }

  clear() async {
    var dbClient = await db;
    await dbClient.execute("DELETE FROM bookdetail");
  }

   drop()async{
    var dbClient = await db ;
    await dbClient.execute("DROP TABLE bookdetail");
    _db = null ;
 }

  Future<int> update(BookDetails bookDetails) async {
    var dbClient = await db;
    final id = await dbClient.update(
      'bookdetail',
      bookDetails.toMap(),
      where: 'id = ?',
      whereArgs: [bookDetails.id],
    );
    return id;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}

