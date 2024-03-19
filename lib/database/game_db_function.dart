import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:savyminds/models/games/question_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class GameLocalDatabase {
  static Future<void> createTable(sql.Database database) async {
    await database.execute('''
        CREATE TABLE $questionDB(
          id INTEGER PRIMARY KEY NOT NULL,
          text TEXT NOT NULL,
          image TEXT NOT NULL,
          options TEXT NOT NULL,
          points INTEGER NOT NULL,
          isGolden INTEGER NOT NULL,
          questionTime INTEGER NOT NULL
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

  static Future<String> addQuestion(QuestionModel question) async {
    final db = await GameLocalDatabase.db();

    await db.insert(questionDB, question.toLocalDBJson(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return 'id';
  }

  static Future<List<QuestionModel>> getAllQuestions() async {
    final db = await GameLocalDatabase.db();
    final result = await db.query(questionDB, orderBy: 'id');
    return result.map((e) => QuestionModel.fromLocalDBJson(e)).toList();
  }

  static Future<List<QuestionModel>> getBatchQuestion() async {
    final db = await GameLocalDatabase.db();
    final result = await db.query(questionDB, orderBy: 'id', limit: 20);
    return result.map((e) => QuestionModel.fromLocalDBJson(e)).toList();
  }

  static Future<void> deleteQuestion(int id) async {
    final db = await GameLocalDatabase.db();
    try {
      await db.delete(questionDB, where: 'id =? ', whereArgs: [id]);
    } catch (e) {
      debugPrint('Error');
    }
  }
}
