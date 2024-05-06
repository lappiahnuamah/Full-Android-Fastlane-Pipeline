import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:savyminds/models/questions/question_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class NewGameLocalDatabase {
  static Future<void> createTable(sql.Database database) async {
    await database.execute('''
        CREATE TABLE $questionDB(
          id INTEGER PRIMARY KEY NOT NULL,
          text TEXT NOT NULL,
          category_weight TEXT NOT NULL,
          difficulty_weight TEXT NOT NULL,
          difficulty TEXT NOT NULL,
          level TEXT NOT NULL,
          image TEXT NOT NULL,
          question_time INTEGER NOT NULL,
          complexity_weight TEXT NOT NULL,
          hint TEXT NOT NULL,
          date_created TEXT NOT NULL,
          has_hint INTEGER NOT NULL,
          is_golden INTEGER NOT NULL,
          has_mystery_box INTEGER NOT NULL,
          has_times_two INTEGER NOT NULL,
          options TEXT NOT NULL,
          categories TEXT NOT NULL,
          
      )
      ''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'path.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTable(database).then((value) {
          log('db created');
        }).onError((error, stackTrace) {
          log('DB created Error $error');
        });
      },
    ).then((value) {
      log('db opened');
      return value;
    }).onError((error, stackTrace) {
      log('DB Open Error $error');
      throw error!;
    });
  }

  static Future<String> addQuestion(NewQuestionModel question) async {
    final db = await NewGameLocalDatabase.db();

    await db.insert(questionDB, question.toLocalDBMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return 'id';
  }

  static Future<List<NewQuestionModel>> getAllQuestions() async {
    final db = await NewGameLocalDatabase.db();
    final result = await db.query(questionDB, orderBy: 'id');
    return result.map((e) => NewQuestionModel.fromLocalDBJson(e)).toList();
  }

  static Future<List<NewQuestionModel>> getBatchQuestion() async {
    final db = await NewGameLocalDatabase.db();
    final result = await db.query(questionDB, orderBy: 'id', limit: 20);
    return result.map((e) => NewQuestionModel.fromLocalDBJson(e)).toList();
  }

  static Future<List<NewQuestionModel>> getLevelQuestions(
      {required String difficulty,required int limit}) async {
    final db = await NewGameLocalDatabase.db();
    final result = await db.query(questionDB,
        orderBy: 'id', where: 'difficulty =? ', whereArgs: [difficulty],limit: limit);
    return result.map((e) => NewQuestionModel.fromLocalDBJson(e)).toList();
  }

  static Future<void> deleteQuestion(int id) async {
    final db = await NewGameLocalDatabase.db();
    try {
      await db.delete(questionDB, where: 'id =? ', whereArgs: [id]);
    } catch (e) {
      debugPrint('Error');
    }
  }
}
