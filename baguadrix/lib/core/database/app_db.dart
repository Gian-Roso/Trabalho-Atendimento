import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@lazySingleton  
class AppDB {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    return await _initDatabase();
  }
  
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    _db = await openDatabase(
      path,
      version: 2,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    return _db!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await _runMigrations(db, version);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE atendimento ADD COLUMN nome_cliente TEXT');
      await db.execute('ALTER TABLE atendimento ADD COLUMN foto_finalizacao TEXT');
    }
  }

  Future<void> _runMigrations(Database db, int version) async {
    final migrationFiles = [
      'lib/core/database/migrations/database.sql',
    ];

    for (final file in migrationFiles) {
      final sql = await rootBundle.loadString(file);
      await db.execute(sql);
    }
  }
}