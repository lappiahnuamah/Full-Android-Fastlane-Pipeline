import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/questions/question_model.dart';
import 'package:sqflite/sqflite.dart';

class NewGameLocalDatabase {
  static Future<void> createTable(Database database) async {
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
          categories TEXT NOT NULL
          
      )
      ''');
    lg("$questionDB table is created");
  }

  static Future<Database> db() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, "db_path.db");
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database database, int version) async {
        await createTable(database).then((value) {
          log('new db created');
        }).onError((error, stackTrace) {
          log('New DB created Error $error');
        });
      },
    ).then((value) {
      log('db opened new');
      return value;
    }).onError((error, stackTrace) {
      log('New DB Open Error $error');
      throw error!;
    });
  }

  static Future<String> addQuestion(NewQuestionModel question) async {
    final db = await NewGameLocalDatabase.db();

    await db.insert(questionDB, question.toLocalDBMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
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
      {required String difficulty, required int limit, int? categoryId}) async {
    final db = await NewGameLocalDatabase.db();

    List<Map<String, Object?>> result = [];
    log('categoryId: $categoryId');
    if (categoryId == null) {
      result = await db.query(questionDB,
          orderBy: 'id',
          where: 'difficulty = ?', 
          whereArgs: [difficulty],
          limit: limit);
    } else {
      await db.rawQuery(
          'SELECT * FROM $questionDB WHERE difficulty = ?  AND categories LIKE ?',
          [difficulty, '%$categoryId%']);
    }
    log('Result: ${result.length}');
    return result.map((e) => NewQuestionModel.fromLocalDBJson(e)).toList();
  }

  static Future<void> deleteQuestion(int id) async {
    final db = await NewGameLocalDatabase.db();
    try {
      await db.delete(questionDB, where: 'id = ? ', whereArgs: [id]);
    } catch (e) {
      debugPrint('Error');
    }
  }
}
