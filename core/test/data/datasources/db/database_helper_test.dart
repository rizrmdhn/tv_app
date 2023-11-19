import 'package:core/core.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/models/movie_table.dart';
import 'package:core/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseHelper databaseHelper;
  late Database? db;

  setUp(() async {
    databaseHelper = DatabaseHelper();
    db = await databaseHelper.database;
    await db?.delete('watchlist');
    await db?.delete('watchlistTv');
  });

  tearDown(() async {
    await db?.delete('watchlist');
    await db?.delete('watchlistTv');
  });

  group('Database Helper', () {
    test('should return database instance', () async {
      expect(db, isA<Database>());
    });

    test('should insert movie to watchlist', () async {
      final result = await databaseHelper.insertWatchlist(testMovieTable);
      expect(result, 1);
    });

    test('should insert tv to watchlist', () async {
      final result = await databaseHelper.insertWatchlistTv(testTvTable);
      expect(result, 1);
    });

    test('should remove movie from watchlist', () async {
      await databaseHelper.removeWatchlist(testMovieTable);

      await databaseHelper.insertWatchlist(testMovieTable);
      final result = await databaseHelper.removeWatchlist(testMovieTable);
      expect(result, 1);
    });

    test('should remove tv from watchlist', () async {
      await databaseHelper.removeWatchlistTv(testTvTable);

      await databaseHelper.insertWatchlistTv(testTvTable);
      final result = await databaseHelper.removeWatchlistTv(testTvTable);
      expect(result, 1);
    });

    test('should return movie by id', () async {
      await databaseHelper.getMovieById(1);

      const movie = MovieTable(
        id: 1,
        title: 'title',
        overview: 'overview',
        posterPath: 'posterPath',
      );

      const rMovie = {
        'id': 1,
        'title': 'title',
        'overview': 'overview',
        'posterPath': 'posterPath',
      };

      await databaseHelper.insertWatchlist(movie);
      final result = await databaseHelper.getMovieById(movie.id);
      expect(result, rMovie);
    });

    test('should return tv by id', () async {
      await databaseHelper.getTvById(1);

      const tv = TvTable(
        id: 1,
        name: 'name',
        overview: 'overview',
        posterPath: 'posterPath',
      );

      const rTv = {
        'id': 1,
        'name': 'name',
        'overview': 'overview',
        'posterPath': 'posterPath',
      };

      await databaseHelper.insertWatchlistTv(tv);
      final result = await databaseHelper.getTvById(tv.id);
      expect(result, rTv);
    });
  });

  test('should get watchlist movie', () async {
    await databaseHelper.getWatchlistMovies();

    const movie = MovieTable(
      id: 1,
      title: 'title',
      overview: 'overview',
      posterPath: 'posterPath',
    );

    await databaseHelper.insertWatchlist(movie);
    final result = await databaseHelper.getWatchlistMovies();
    expect(result, isNotEmpty);
  });

  test('should get watchlist tv', () async {
    await databaseHelper.getWatchlistTvs();

    const tv = TvTable(
      id: 1,
      name: 'name',
      overview: 'overview',
      posterPath: 'posterPath',
    );

    await databaseHelper.insertWatchlistTv(tv);
    final result = await databaseHelper.getWatchlistTvs();
    expect(result, isNotEmpty);
  });
}
