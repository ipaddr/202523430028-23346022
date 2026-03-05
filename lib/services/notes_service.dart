// Week 4 - Working with Streams in Notes Service
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesService {
  static Database? _db;

  final StreamController<List<Map<String, dynamic>>> _notesStreamController =
      StreamController.broadcast();

  Stream<List<Map<String, dynamic>>> get allNotes =>
      _notesStreamController.stream;

  // =========================
  // DATABASE
  // =========================

  Future<Database> get database async {
    if (_db != null) return _db!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT NOT NULL
          )
        ''');
      },
    );

    return _db!;
  }

  // =========================
  // CREATE NOTE
  // =========================

  Future<void> createNote(String text) async {
    final db = await database;

    await db.insert(
      'notes',
      {'text': text},
    );

    await _emitNotes();
  }

  // =========================
  // READ NOTES
  // =========================

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await database;

    final notes = await db.query(
      'notes',
      orderBy: 'id DESC',
    );

    return notes;
  }

  // =========================
  // UPDATE NOTE
  // =========================

  Future<void> updateNote(int id, String text) async {
    final db = await database;

    await db.update(
      'notes',
      {'text': text},
      where: 'id = ?',
      whereArgs: [id],
    );

    await _emitNotes();
  }

  // =========================
  // DELETE NOTE
  // =========================

  Future<void> deleteNote(int id) async {
    final db = await database;

    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    await _emitNotes();
  }

  // =========================
  // EMIT STREAM DATA
  // =========================

  Future<void> _emitNotes() async {
    final notes = await getAllNotes();
    _notesStreamController.add(notes);
  }

  // =========================
  // LOAD FIRST DATA
  // =========================

  Future<void> init() async {
    await database;
    await _emitNotes();
  }

  // =========================
  // CLOSE STREAM
  // =========================

  void dispose() {
    _notesStreamController.close();
  }
}