import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('reviews.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reviews (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reviewer_name TEXT,
        movie_title TEXT,
        rating TEXT,
        review_text TEXT
      )
    ''');
  }

  // INSERT
  Future<int> insertReview(
    String reviewerName,
    String movieTitle,
    String rating,
    String reviewText,
  ) async {
    final db = await instance.database;
    return await db.insert('reviews', {
      'reviewer_name': reviewerName,
      'movie_title': movieTitle,
      'rating': rating,
      'review_text': reviewText,
    });
  }

  // READ
  Future<List<Map<String, dynamic>>> getAllReviews() async {
    final db = await instance.database;
    return await db.query('reviews');
  }

  // UPDATE
  Future<int> updateReview(
    int id,
    String reviewerName,
    String movieTitle,
    String rating,
    String reviewText,
  ) async {
    final db = await instance.database;
    return await db.update(
      'reviews',
      {
        'reviewer_name': reviewerName,
        'movie_title': movieTitle,
        'rating': rating,
        'review_text': reviewText,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE
  Future<int> deleteReview(int id) async {
    final db = await instance.database;
    return await db.delete(
      'reviews',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}