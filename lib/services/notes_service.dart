import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesService {
  static Database? _db;

  // =========================
  // DATABASE INITIALIZATION
  // =========================

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // =========================
  // CREATE
  // =========================

  Future<int> createNote(String text) async {
    final db = await database;

    return await db.insert(
      'notes',
      {
        'text': text,
      },
    );
  }

  // =========================
  // READ ALL
  // =========================

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await database;

    return await db.query('notes', orderBy: 'id DESC');
  }

  // =========================
  // UPDATE
  // =========================

  Future<int> updateNote(int id, String newText) async {
    final db = await database;

    return await db.update(
      'notes',
      {'text': newText},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // =========================
  // DELETE
  // =========================

  Future<int> deleteNote(int id) async {
    final db = await database;

    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}