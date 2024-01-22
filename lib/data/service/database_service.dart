import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:voice_travel/data/model/translate_record.dart';

import '../model/language.dart';

class DatabaseService {
  late Database database;
  static const favouriteTableName = "favourite";
  static const historyTableName = "history";

  Future<Database> getDB() async {
    database = await initDB();
    return database;
  }

  Future<Database> initDB() async {
    var dbName = 'data.db';
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, dbName);
    var exist = await databaseExists(path);
    if (!exist) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join('assets', dbName));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
    }
    return await openDatabase(path);
  }

  Future<List<TranslateRecord>> getFav() async {
    final List<Map<String, dynamic>> maps = await database.query(favouriteTableName);
    List<TranslateRecord> allList = List.generate(maps.length, (index) {
      return TranslateRecord(
          sourceLanguage: Language.fromJsonString(maps[index]['sourceLanguage']),
          targetLanguage:  Language.fromJsonString(maps[index]['targetLanguage']),
          sourceText:  maps[index]['sourceText'],
          targetText:  maps[index]['targetText']);
    });
    return allList.toList();
  }

  Future<void> addFav(TranslateRecord record) async {
    String source = record.sourceLanguage.toJsonString();
    String target = record.targetLanguage.toJsonString();
    String sql = 'INSERT INTO \'$favouriteTableName\' VALUES (\'${source}\', \'${target}\', \'${record.sourceText}\', \'${record.targetText}\');';
    await database.rawInsert(sql);
  }

  Future<void> deleteFav(TranslateRecord record) async {
    String source = record.sourceLanguage.toJsonString();
    String target = record.targetLanguage.toJsonString();
    String sql = 'DELETE FROM \'$favouriteTableName\' WHERE sourceLanguage = \'${source}\' AND targetLanguage = \'${target}\' AND sourceText = \'${record.sourceText}\' AND targetText = \'${record.targetText}\'';
    await database.rawDelete(sql);
  }

  Future<void> deleteAllFav() async {
    String sql = "DELETE FROM \'$favouriteTableName\'";
    await database.rawDelete(sql);
  }

  Future<bool> isFav(TranslateRecord record) async {
    String source = record.sourceLanguage.toJsonString();
    String target = record.targetLanguage.toJsonString();
    String sql = 'SELECT from \'$favouriteTableName\' WHERE sourceLanguage = \'${source}\' AND targetLanguage = \'${target}\' AND sourceText = \'${record.sourceText}\' AND targetText = \'${record.targetText}\'';
    final List<Map<String, dynamic>> maps = await database.rawQuery(sql);
    return maps.isNotEmpty;
  }

  Future<List<TranslateRecord>> getHistory() async {
    final List<Map<String, dynamic>> maps = await database.query(historyTableName);
    List<TranslateRecord> allList = List.generate(maps.length, (index) {
      return TranslateRecord(
          sourceLanguage: Language.fromJsonString(maps[index]['sourceLanguage']),
          targetLanguage:  Language.fromJsonString(maps[index]['targetLanguage']),
          sourceText:  maps[index]['sourceText'],
          targetText:  maps[index]['targetText']);
    });
    return allList.toList();
  }

  Future<void> addHistory(TranslateRecord record) async {
    String source = record.sourceLanguage.toJsonString();
    String target = record.targetLanguage.toJsonString();
    String sql = 'INSERT INTO \'$historyTableName\' VALUES (\'${source}\', \'${target}\', \'${record.sourceText}\', \'${record.targetText}\');';
    await database.rawInsert(sql);
  }

  Future<void> deleteHistory(TranslateRecord record) async {
    String source = record.sourceLanguage.toJsonString();
    String target = record.targetLanguage.toJsonString();
    String sql = 'DELETE FROM \'$historyTableName\' WHERE sourceLanguage = \'${source}\' AND targetLanguage = \'${target}\' AND sourceText = \'${record.sourceText}\' AND targetText = \'${record.targetText}\'';
    await database.rawDelete(sql);
  }

  Future<void> deleteAllHistory() async {
    String sql = "DELETE FROM \'$historyTableName\'";
    await database.rawDelete(sql);
  }
}