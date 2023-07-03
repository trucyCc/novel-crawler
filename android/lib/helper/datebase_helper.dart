import 'package:android/model/bookshelf_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  DatabaseHelper._();

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'crawler_novel.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS bookshelf (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      coverUrl TEXT,
      bookName TEXT,
      source TEXT,
      bookId TEXT,
      bookLastChapterName TEXT,
      chapterId TEXT,
      readLastChapterName TEXT,
      readLastChapterUrl TEXT
    )
  ''');
  }

  static Future<void> saveBook(BookShelfItem book) async {
    Database db = await DatabaseHelper.database;
    await db.insert(
      'bookshelf',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> delBook(bookId, bookName) async {
    Database db = await DatabaseHelper.database;
    await db.delete('bookshelf',
        where: 'bookId = ? and bookName = ?', whereArgs: [bookId, bookName]);
  }


  static Future<List<BookShelfItem>> loadBooks() async {
    Database db = await DatabaseHelper.database;
    List<Map<String, dynamic>> results = await db.query('bookshelf');
    return results.map((row) => BookShelfItem.fromMap(row)).toList();
  }

  static Future<BookShelfItem?> searchBookByIdAndName(bookId, bookName) async {
    Database db = await DatabaseHelper.database;
    List<Map<String, dynamic>> results = await db.query('bookshelf',
        where: 'bookId = ? and bookName = ?', whereArgs: [bookId, bookName]);
    if (results.isEmpty) {
      return null;
    }
    return BookShelfItem.fromMap(results[0]);
  }

  static Future<void> updateBookShelfItemByIdAndName(
      bookId, bookName, chapterName, chapterUrl) async {
    Database db = await DatabaseHelper.database;
    await db.update(
      'bookshelf',
      {
        'readLastChapterName': chapterName,
        'readLastChapterUrl': chapterUrl,
      },
      where: 'bookId = ? and bookName = ?',
      whereArgs: [bookId, bookName],
    );
  }
}
