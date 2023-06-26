import 'package:android/model/bookshelf_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'crawler_novel.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS bookshelf (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      book_source TEXT,
      last_chapter_url TEXT,
      last_chapter_name TEXT,
      book_cover_url TEXT,
      created_at TEXT
    )
  ''');
  }

  Future<void> saveBook(BookShelfItem book) async {
    Database db = await instance.database;
    await db.insert(
      'bookshelf',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BookShelfItem>> loadBooks() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query('bookshelf');
    return results.map((row) => BookShelfItem.fromMap(row)).toList();
  }
}
