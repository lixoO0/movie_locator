import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../constants/app_constants.dart';

part 'app_database.g.dart';

// Note: After running build_runner, MoviesData type will be available
// Run: flutter pub run build_runner build --delete-conflicting-outputs

/// Movies table for caching movie data
class Movies extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  TextColumn get overview => text()();
  RealColumn get voteAverage => real()();
  IntColumn get voteCount => integer()();
  TextColumn get releaseDate => text()();
  TextColumn get posterPath => text().nullable()();
  TextColumn get backdropPath => text().nullable()();
  TextColumn get originalLanguage => text()();
  TextColumn get originalTitle => text()();
  BoolColumn get adult => boolean().withDefault(const Constant(false))();
  BoolColumn get video => boolean().withDefault(const Constant(false))();
  RealColumn get popularity => real()();
  
  // Cache metadata
  DateTimeColumn get cachedAt => dateTime()();
  TextColumn get category => text()(); // popular, top_rated, now_playing, upcoming, search
  
  @override
  Set<Column> get primaryKey => {id};
}

/// Favorites table for storing user favorites
class Favorites extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  TextColumn get overview => text()();
  RealColumn get voteAverage => real()();
  TextColumn get posterPath => text().nullable()();
  TextColumn get type => text()(); // 'movie' or 'tv_show'
  DateTimeColumn get addedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Movies, Favorites])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => AppConstants.databaseVersion;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle migrations here
      },
    );
  }

  // Movies queries
  Future<List<Movy>> getAllMovies() => select(movies).get();
  
  Future<List<Movy>> getMoviesByCategory(String category) {
    return (select(movies)..where((m) => m.category.equals(category))).get();
  }
  
  Future<Movy?> getMovieById(int id) {
    return (select(movies)..where((m) => m.id.equals(id))).getSingleOrNull();
  }
  
  Future<void> insertMovies(List<MoviesCompanion> moviesList) async {
    await batch((batch) {
      batch.insertAll(movies, moviesList, mode: InsertMode.replace);
    });
  }
  
  Future<void> clearMoviesByCategory(String category) async {
    await (delete(movies)..where((m) => m.category.equals(category))).go();
  }
  
  Future<void> clearAllMovies() => delete(movies).go();
  
  // Favorites queries
  Future<List<Favorite>> getAllFavorites() => select(favorites).get();
  
  Future<List<Favorite>> getFavoritesByType(String type) {
    return (select(favorites)..where((f) => f.type.equals(type))).get();
  }
  
  Future<Favorite?> getFavoriteById(int id) {
    return (select(favorites)..where((f) => f.id.equals(id))).getSingleOrNull();
  }
  
  Future<void> insertFavorite(FavoritesCompanion favorite) async {
    await into(favorites).insert(favorite, mode: InsertMode.replace);
  }
  
  Future<void> deleteFavorite(int id) async {
    await (delete(favorites)..where((f) => f.id.equals(id))).go();
  }
  
  Future<bool> isFavorite(int id) async {
    final favorite = await getFavoriteById(id);
    return favorite != null;
  }
  
  Future<void> clearAllFavorites() => delete(favorites).go();
  
  // Clean old cache (older than cache duration)
  Future<void> cleanOldCache() async {
    final cacheExpiry = DateTime.now().subtract(
      Duration(hours: AppConstants.cacheDurationHours),
    );
    await (delete(movies)..where((m) => m.cachedAt.isSmallerThanValue(cacheExpiry))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseName));
    return NativeDatabase(file);
  });
}

