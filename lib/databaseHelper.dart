import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'note.dart';
import 'dart:async';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; // singleton database helper
  static Database? _database;

  String noteTable = 'note_table';
  String clId = 'id';
  String clTitle = 'title';
  String clDescription = 'description';
  String clDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initialize();
    return _database!;
  }

  Future<Database> initialize() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}note.db';

    var notDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($clId INTEGER PRIMARY KEY AUTOINCREMENT, $clTitle TEXT, $clDescription TEXT, $clDate TEXT)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await database;

    var result = await db.query(noteTable, orderBy: '$clId DESC');
    return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    var db = await database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$clId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> trancateDatabase() async {
    var db = await database;
    int result = await db.delete(noteTable);
    return result;
  }

  Future<int> deleteNote(int id) async {
    var db = await database;
    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $clId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*)  from $noteTable');
    int? result = Sqflite.firstIntValue(x);
    return result!;
  }

  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = [];
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
