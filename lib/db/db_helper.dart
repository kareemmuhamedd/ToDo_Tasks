import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import '/models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> initDb() async {
    /// if data base is not empty i will out from function
    if (_db != null) {
      debugPrint('@@@### not null db');
      return;
    } else {
      try {
        String path = '${await getDatabasesPath()}task.db';
        debugPrint('@@@### in database path');
        _db = await openDatabase(
          path,
          version: _version,
          onCreate: (
            Database db,
            int version,
          ) async {
            debugPrint('@@@###creating a new one');
            // When creating the db, create the table
            await db.execute(
              'CREATE TABLE $_tableName ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'title TEXT, note TEXT, date STRING, '
              'startTime STRING, endTime STRING, '
              'remind INTEGER, repeat STRING, '
              'color INTEGER, '
              'isCompleted INTEGER)',
            );
          },
        );
        print('@@@@ DATA BASE Created');
      } catch (e) {
        print('geeeeeeeeeeeeeeeeeeeeeeeeeerrrrrrrrrrr $e');
      }
    }
  }

  static Future<int> insert(Task? task) async {
    /// the returned value is int because it will be the id
    print('@@@@@insert function called');
    try {
      return await _db!.insert(_tableName, task!.toJson());
    } catch (e) {
      print('We are here =#=#=#=#=#=#=#=> $e');
      return 99999;
    }
  }

  static Future<int> delete(Task task) async {
    print('@@@###delete function called');
    return await _db!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<int> deleteAll() async {
    print('@@@###delete All function called');
    return await _db!.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    /// الداله دي مبتستقبلش حاجة هى وظيفتها بس ان هي تستفسر عن شوية بيانات من الداتابيز
    print('@@@###query function called');
      return await _db!.query(_tableName);
  }

  static Future<int> update(int id) async {
    print('@@@###update function called');
    return await _db!.rawUpdate('''
    UPDATE $_tableName
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]

        /// شرح جزء ال update عشان مهم
        /// look why i put [1, id]
        /// Because if i need to update state of task i will need to make it complete
        /// so i need to put the value of isCompleted = 1
        /// so in these order [1, id]
        /// the first isCompleted will take 1
        /// and the second id wil take id because i need to update instead of the id whose i will receive

        );
  }
}
