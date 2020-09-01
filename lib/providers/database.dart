
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'transactions.db'), //Path for db
      onCreate: (db, version) async {
        await db.execute('''  
          CREATE TABLE transactions(
            id TEXT PRIMARY KEY,
            title TEXT,
            amount DOUBLE,
            date TEXT
          )
        ''');
      },
      version: 1,
    );
  }

Future<int> insertTransaction(Map<String, dynamic> trans) async {
    final db = await database;
    final res = await db.rawInsert(''' 
        INSERT INTO transactions(id,title,amount,date)
        VALUES(?,?,?,?)
    ''', [
      trans['id'],
      trans['title'],
      trans['amount'],
      trans['date'],
    ]);
    return res;
  }

 Future<List<Map<String,dynamic>>> getAllTransactions() async{
      final db = await database;
      final res = await db.query("transactions");
      if(res.isEmpty)return null;
      return res;
  }

  Future<dynamic> getTransactionById(String id) async{
      final db = await database;
      final res = await db.query('transactions', where: 'id=?', whereArgs: [id]);
      return res.isNotEmpty ? res.first : null;
  }

  Future<int> deleteTransactionDB(String id) async{
      final db = await database;
      //final res = await db.delete('transactions',  where: 'id=?', whereArgs: [id]);
      final res = await db.rawDelete(''' 
          DELETE FROM transactions
          WHERE id = ?
      ''',[id]);
      return res;
  }

}
