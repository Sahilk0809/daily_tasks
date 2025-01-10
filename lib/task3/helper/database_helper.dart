import 'package:daily_tasks/task3/modal/users_modal.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static DatabaseHelper databaseHelper = DatabaseHelper._();
  Database? _database;

  Future<Database> get database async => _database ?? await initDatabase();

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_manager.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT,
            role TEXT,
            avatar TEXT,
            creationAt TEXT,
            updatedAt TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertUser(UsersModal user) async {
    final db = await database;
    String sql = '''
    INSERT INTO users (id, name, email, role, avatar, creationAt, updatedAt) VALUES (?, ?, ?, ?, ?, ?, ?);
    ''';
    List args = [
      user.id,
      user.name,
      user.email,
      user.role.name,
      user.avatar,
      "${user.creationAt.day}/${user.creationAt.month}/${user.creationAt.year}  ${user.creationAt.hour}:${user.creationAt.minute}:${user.creationAt.second}",
      "${user.updatedAt.day}/${user.updatedAt.month}/${user.updatedAt.year}  ${user.updatedAt.hour}:${user.updatedAt.minute}:${user.creationAt.second}",
    ];
    await db.rawInsert(sql, args);
  }

  Future<List<Map<String, Object?>>> getUsers() async {
    final db = await database;
    String sql = '''
    SELECT * FROM users;
    ''';
    return await db.rawQuery(sql);
  }

  Future<void> updateData(DatabaseUsers user) async {
    final db = await database;
    String sql = '''
    UPDATE users SET 
    name = ?,
    email = ?,
    role = ?,
    avatar = ?,
    creationAt = ?,
    updatedAt = ?
    WHERE 
    id = ?;
    ''';
    List args = [
      user.name,
      user.email,
      user.role,
      user.avatar,
      user.creationAt,
      user.updatedAt,
      user.id
    ];
    await db.rawUpdate(sql, args);
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    String sql = '''
    DELETE FROM users WHERE id = ?
    ''';
    List args = [id];
    await db.rawDelete(sql, args);
  }

  Future<void> deleteAllUsers() async {
    final db = await database;
    await db.delete('users');
  }
}
