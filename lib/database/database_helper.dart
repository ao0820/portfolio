import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/exercise.dart';
import '../models/workout_record.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('training_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    // Create exercises table
    await db.execute('''
      CREATE TABLE exercises (
        id $idType,
        name $textType,
        category $textType,
        createdAt $textType
      )
    ''');

    // Create workout_records table
    await db.execute('''
      CREATE TABLE workout_records (
        id $idType,
        exerciseId $integerType,
        sets $integerType,
        reps $integerType,
        durationMinutes $integerType,
        recordedAt $textType,
        FOREIGN KEY (exerciseId) REFERENCES exercises (id) ON DELETE CASCADE
      )
    ''');
  }

  // ========== Exercise CRUD Operations ==========

  Future<Exercise> createExercise(Exercise exercise) async {
    final db = await database;
    final id = await db.insert('exercises', exercise.toMap());
    return exercise.copyWith(id: id);
  }

  Future<Exercise?> readExercise(int id) async {
    final db = await database;
    final maps = await db.query('exercises', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Exercise.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Exercise>> readAllExercises() async {
    final db = await database;
    const orderBy = 'createdAt DESC';
    final result = await db.query('exercises', orderBy: orderBy);
    return result.map((map) => Exercise.fromMap(map)).toList();
  }

  Future<int> updateExercise(Exercise exercise) async {
    final db = await database;
    return db.update(
      'exercises',
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<int> deleteExercise(int id) async {
    final db = await database;
    return await db.delete('exercises', where: 'id = ?', whereArgs: [id]);
  }

  // ========== WorkoutRecord CRUD Operations ==========

  Future<WorkoutRecord> createWorkoutRecord(WorkoutRecord record) async {
    final db = await database;
    final id = await db.insert('workout_records', record.toMap());
    return record.copyWith(id: id);
  }

  Future<WorkoutRecord?> readWorkoutRecord(int id) async {
    final db = await database;
    final maps = await db.query(
      'workout_records',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return WorkoutRecord.fromMap(maps.first);
    }
    return null;
  }

  Future<List<WorkoutRecord>> readAllWorkoutRecords() async {
    final db = await database;
    const orderBy = 'recordedAt DESC';
    final result = await db.query('workout_records', orderBy: orderBy);
    return result.map((map) => WorkoutRecord.fromMap(map)).toList();
  }

  Future<List<WorkoutRecord>> readWorkoutRecordsByExercise(
    int exerciseId,
  ) async {
    final db = await database;
    final result = await db.query(
      'workout_records',
      where: 'exerciseId = ?',
      whereArgs: [exerciseId],
      orderBy: 'recordedAt DESC',
    );
    return result.map((map) => WorkoutRecord.fromMap(map)).toList();
  }

  Future<List<WorkoutRecord>> readWorkoutRecordsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final result = await db.query(
      'workout_records',
      where: 'recordedAt BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'recordedAt ASC',
    );
    return result.map((map) => WorkoutRecord.fromMap(map)).toList();
  }

  Future<int> updateWorkoutRecord(WorkoutRecord record) async {
    final db = await database;
    return db.update(
      'workout_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteWorkoutRecord(int id) async {
    final db = await database;
    return await db.delete('workout_records', where: 'id = ?', whereArgs: [id]);
  }

  // ========== Analytics Queries ==========

  Future<Map<String, int>> getExerciseDistribution() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT e.name, COUNT(w.id) as count
      FROM exercises e
      LEFT JOIN workout_records w ON e.id = w.exerciseId
      GROUP BY e.id, e.name
      HAVING count > 0
      ORDER BY count DESC
    ''');

    final Map<String, int> distribution = {};
    for (var row in result) {
      distribution[row['name'] as String] = row['count'] as int;
    }
    return distribution;
  }

  Future<Map<DateTime, int>> getDailyVolume(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT recordedAt, SUM(sets * reps) as totalVolume
      FROM workout_records
      WHERE recordedAt BETWEEN ? AND ?
      GROUP BY DATE(recordedAt)
      ORDER BY recordedAt ASC
    ''',
      [startDate.toIso8601String(), endDate.toIso8601String()],
    );

    final Map<DateTime, int> dailyVolume = {};
    for (var row in result) {
      final date = DateTime.parse(row['recordedAt'] as String);
      final dateOnly = DateTime(date.year, date.month, date.day);
      dailyVolume[dateOnly] = row['totalVolume'] as int;
    }
    return dailyVolume;
  }

  Future<int> getTotalWorkoutCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM workout_records',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getTotalExerciseCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM exercises');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
