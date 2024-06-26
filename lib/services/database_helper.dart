import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:my_generative_ai_app/models/message.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'my_database.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE messages(
        id INTEGER PRIMARY KEY,
        text TEXT,
        time TEXT,
        isUserMessage INTEGER
      )
    ''');
  }

  Future<void> removeMessage(int id) async {
    final db = await instance.database;
    await db.delete(
      'messages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Modifikasi disini
  Future<void> deleteAllMessages() async {
    final db = await database;
    await db.delete('messages');
  }

  Future<void> insertMessage(Message message) async {
    final db = await instance.database;
    await db.insert(
      'messages',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Message>> getMessages() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('messages');
    return List.generate(maps.length, (i) {
      return Message(
        id: maps[i]['id'],
        text: maps[i]['text'],
        time: maps[i]['time'],
        isUserMessage: maps[i]['isUserMessage'] == 1,
      );
    });
  }
}
