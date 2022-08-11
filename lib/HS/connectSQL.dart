/*
import 'package:flutter/services.dart';
import 'package:senior_project/HS/guideSQL.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String mainTableName = 'guidesql';

class DBHelper {
  var _db;

  // DB 생성
  Future<Database> get database async {
    if (_db != null) return _db;
    _db = openDatabase(
      join(await getDatabasesPath(), 'assetportfolio.db'),
      onCreate: (db, version) => _createDb(db),
      version: 1,
    );
    return _db;

  }

  // DB table 생성
  void _createDb(Database db) {
    db.execute("CREATE TABLE guidesql(index1 INTEGER, index2 INTEGER, index3 INTEGER PRIMARY KEY, txt TEXT)");
  }

  // Create(Insert) 메소드
  Future<void> insertGuideSql(GuideSQL guidesql) async {
    final db = await database;

    await db.insert(
      mainTableName, //테이블 명
      guidesql.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, //기본키 중복시 대체
    );

    Future<List(GuideSQL)>> getAllGuideline() async {
      final db = await database;

      // 모든 AssetPortfolio를 얻기 위해 테이블에 질의합니다.
      final List<Map<String, dynamic>> maps = await db.query('assetportfolio');

      // List<Map<String, dynamic>를 List<AssetPortfolio>으로 변환합니다.
      return List.generate(maps.length, (i) {
        return AssetPortfolio(
          kind: maps[i]['kind'],
          asset: maps[i]['asset'],
          safety: maps[i]['safety'],
          percent: maps[i]['percent'],
          money: maps[i]['money'],
        );
      });
    }
  }
}
 */