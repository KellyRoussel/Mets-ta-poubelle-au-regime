import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mouvement_de_palier/model/record.dart';
import 'package:mouvement_de_palier/model/personal_challenge.dart';
import 'package:mouvement_de_palier/model/team_challenge.dart';
import 'package:mouvement_de_palier/step.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ChallengeDatabase {
  static final ChallengeDatabase _instance = ChallengeDatabase._privateConstructor();

  static Database? _database;
  static String dbName  = "challenge.db";

  ChallengeDatabase._privateConstructor();

  factory ChallengeDatabase() {
    return _instance;
  }

  Future<Database> get database async {
    return _database ?? await _initDB(dbName);
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  String _addForeignKey(field, referenceTable, referenceField){
    return "FOREIGN KEY ($field) REFERENCES $referenceTable ($referenceField) "
        "ON DELETE NO ACTION ON UPDATE NO ACTION";
  }

  Future _createDB(Database db, int version) async {
    print("===> Creating DB");

    final autoIdType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final idType = 'INTEGER PRIMARY KEY';
    final textType = 'TEXT NOT NULL';
    final floatType = 'FLOAT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $recordTable ( 
  ${RecordFields.id} $autoIdType, 
  ${RecordFields.datetime} $textType,
  ${RecordFields.weight} $floatType
  )
''');

    await db.execute('''
CREATE TABLE $stepTable ( 
  ${StepFields.id} $idType
  )
''');

    await db.execute('''
CREATE TABLE $personalChallengeTable ( 
  ${PersonalChallengeFields.id} $autoIdType, 
  ${PersonalChallengeFields.text} $textType,
  ${PersonalChallengeFields.validated} $boolType,
   ${PersonalChallengeFields.stepId} $integerType,
   ${_addForeignKey(PersonalChallengeFields.stepId,
    stepTable, StepFields.id)}
  )
''');

    await db.execute('''
CREATE TABLE $teamChallengeTable ( 
  ${TeamChallengeFields.id} $autoIdType, 
  ${TeamChallengeFields.text} $textType,
  ${TeamChallengeFields.success} $boolType,
   ${TeamChallengeFields.stepId} $integerType,
   ${_addForeignKey(TeamChallengeFields.stepId,
        stepTable, StepFields.id)}
  )
''');

    // inserts initiaux => ceux des fichiers json ?
    // STEP + Personal Challenges
   await _insertInitialData(db);

    var dir = await getApplicationDocumentsDirectory();
    String _dbPath = dir.path + '/$dbName';
    print("BD PATH : $_dbPath");
  }

  Future _insertInitialData(Database db) async{
    print("===> Inserting initial data");
    List<String> stepFiles = ["step1.json", "step2.json", "step3.json"];
    for(String stepFile in stepFiles){
      String data = await rootBundle.loadString("assets/$stepFile");
      final jsonResult = jsonDecode(data);
      int stepId = jsonResult["id"];
      await db.insert(stepTable, {
        StepFields.id : stepId
      });
      List<String> commonPersonalChallenges = jsonResult["personal_challenges"].cast<String>();
      for(String commonPersonalChallenge in commonPersonalChallenges){
        await db.insert(personalChallengeTable, {
          PersonalChallengeFields.id: null,
          PersonalChallengeFields.text: commonPersonalChallenge,
          PersonalChallengeFields.validated: false.toString(),
          PersonalChallengeFields.stepId: stepId
        });
      }

      List<String> teamChallenges = jsonResult["team_challenges"].cast<String>();
      for(String teamChallenge in teamChallenges){
        await db.insert(teamChallengeTable, {
          TeamChallengeFields.id: null,
          TeamChallengeFields.text: teamChallenge,
          TeamChallengeFields.success: false.toString(),
          TeamChallengeFields.stepId: stepId
        });
      }


    }
  }

  Future<Record> createRecord(Record record) async {
    final db = await database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(recordTable, record.toJson());
    record.id=id;
    return record;
  }

  Future<PersonalChallenge> createPersonalChallenge(PersonalChallenge personalChallenge) async {
    final db = await database;

    final id = await db.insert(personalChallengeTable, personalChallenge.toJson());
    personalChallenge.id=id;
    return personalChallenge;
  }

  Future<Record> readRecord(int id) async {
    final db = await database;

    final maps = await db.query(
      recordTable,
      columns: RecordFields.values,
      where: '${RecordFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Record.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<PersonalChallenge> readPersonalChallenge(int id) async {
    final db = await database;

    final maps = await db.query(
      personalChallengeTable,
      columns: PersonalChallengeFields.values,
      where: '${PersonalChallengeFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PersonalChallenge.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Record>> readAllRecords() async {
    final db = await database;

    const orderBy = '${RecordFields.datetime} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(recordTable, orderBy: orderBy);

    return result.map((json) => Record.fromJson(json)).toList();
  }

  Future<List<PersonalChallenge>> readAllPersonalChallenges() async {
    final db = await database;

    //const orderBy = '${PersonalChallengeFields.datetime} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(personalChallengeTable,
    //    orderBy: orderBy
    );

    return result.map((json) => PersonalChallenge.fromJson(json)).toList();
  }

  Future<List<PersonalChallenge>> readAllPersonalChallengesForStep(int stepId) async {
    print("===> Reading all personal challenges for step : $stepId");
    final db = await database;

    const orderBy = '${PersonalChallengeFields.id} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(personalChallengeTable,
          orderBy: orderBy,
      where: '${PersonalChallengeFields.stepId} = ?',
      whereArgs: [stepId]
    );

    return result.map((json) => PersonalChallenge.fromJson(json)).toList();
  }

  Future<List<TeamChallenge>> readAllTeamChallengesForStep(int stepId) async {
    print("===> Reading all team challenges for step : $stepId");
    final db = await database;

    const orderBy = '${TeamChallengeFields.id} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(teamChallengeTable,
        orderBy: orderBy,
        where: '${TeamChallengeFields.stepId} = ?',
        whereArgs: [stepId]
    );

    return result.map((json) => TeamChallenge.fromJson(json)).toList();
  }

  Future<int> updateRecord(Record record) async {
    final db = await database;

    return db.update(
      recordTable,
      record.toJson(),
      where: '${RecordFields.id} = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> updatePersonalChallenge(PersonalChallenge personalChallenge) async {
    final db = await database;

    return db.update(
      personalChallengeTable,
      personalChallenge.toJson(),
      where: '${PersonalChallengeFields.id} = ?',
      whereArgs: [personalChallenge.id],
    );
  }

  Future<int> updateTeamChallenge(TeamChallenge teamChallenge) async {
    final db = await database;

    return db.update(
      teamChallengeTable,
      teamChallenge.toJson(),
      where: '${TeamChallengeFields.id} = ?',
      whereArgs: [teamChallenge.id],
    );
  }

  Future<int> deleteRecord(int id) async {
    final db = await database;

    return await db.delete(
      recordTable,
      where: '${RecordFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletePersonalChallenge(int id) async {
    final db = await database;

    return await db.delete(
      personalChallengeTable,
      where: '${PersonalChallengeFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await database;

    db.close();
  }
}