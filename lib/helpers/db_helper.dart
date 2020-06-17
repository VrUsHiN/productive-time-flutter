import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database() async{
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'items.db'),
      onCreate: (db, version) async{
        await db.execute(
            'CREATE TABLE user_items(id TEXT PRIMARY KEY, isChecked INTEGER)');
        await db.execute('CREATE TABLE user_target(id TEXT PRIMARY KEY, target INTEGER)');
        await db.execute('CREATE TABLE user_date(id TEXT PRIMARY KEY, date TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> checkResetNeeded() async{
    final dataList = await DBHelper.getData('user_date');
    final dateStored = dataList[0]['date'];
    final tempDate = DateTime.now();
    final dateToday = (tempDate.day+tempDate.month+tempDate.year).toString();

    if(dateToday.compareTo(dateStored)!=0){
      resetDatabase();
    }
  }

  static Future<void> resetDatabase() async{
    for (int i = 0; i < TimeOfDay.hoursPerDay; i++) {
      DBHelper.insert(
        'user_items',
        {
          'id': i.toString(),
          'isChecked': 0, //false
        },
      );//.then((value) => print('no'));
    }
    DBHelper.insert('user_target', {'id': 'none','target': 8,});
    final temp = DateTime.now();
    DBHelper.insert('user_date', {'id': 'none','date': (temp.day+temp.month+temp.year).toString(),});
  }

  static Future<void> initialiseDatabase() async{ 
    if(await sql.databaseExists(path.join(await sql.getDatabasesPath(),'items.db'))){
      //print('yes');
      DBHelper.checkResetNeeded();
    }
    else{
//      for (int i = 0; i < TimeOfDay.hoursPerDay; i++) {
//        DBHelper.insert(
//          'user_items',
//          {
//            'id': i.toString(),
//            'isChecked': 0, //false
//          },
//        );//.then((value) => print('no'));
//      }
//      DBHelper.insert('user_target', {'id': 'none','target': 8,});
      DBHelper.resetDatabase();
//      final temp = DateTime.now();
//      DBHelper.insert('user_date', {'id': 'none','date': (temp.day+temp.month+temp.year).toString(),});//.then((value) => print('HAHAHA'));
    }
  }

  static Future<List<Map<String,dynamic>>> getData(String table) async{
    final sqlDb = await DBHelper.database();
    return sqlDb.query(table);
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final sqlDb = await DBHelper.database();
    await sqlDb.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> update(String table, Map<String, dynamic> data,String id) async {
    final sqlDb = await DBHelper.database();
    await sqlDb.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
