import 'dart:async';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblWatchlist = 'watchlist';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        '''
      CREATE TABLE  $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  Future<int> insertWatchlist(dynamic data) async {
    final db = await database;
    if (data is MovieTable) {
      return await db!.insert(_tblWatchlist, data.toJson());
    } else if (data is TvTable) {
      return await db!.insert(_tblWatchlist, data.toJson());
    } else {
      throw Exception('Unknown data type');
    }
  }

  Future<int> removeWatchlist(dynamic data) async {
    final db = await database;
    if (data is MovieTable) {
      return await db!.delete(
        _tblWatchlist,
        where: 'id = ?',
        whereArgs: [data.id],
      );
    } else if (data is TvTable) {
      return await db!.delete(
        _tblWatchlist,
        where: 'id = ?',
        whereArgs: [data.id],
      );
    } else {
      throw Exception('Unknown data type');
    }
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchlist);

    return results;
  }
}
