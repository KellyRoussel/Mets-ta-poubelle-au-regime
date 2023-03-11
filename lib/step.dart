import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:mouvement_de_palier/model/personal_challenge.dart';
import 'package:mouvement_de_palier/model/quizz.dart';
import 'package:mouvement_de_palier/model/survey.dart';
import 'package:mouvement_de_palier/model/team_challenge.dart';
import 'package:provider/provider.dart';

import 'db/challenge_db.dart';
import 'model/icebreaker.dart';
import 'model/resource.dart';

const String stepTable = "step";

class StepFields{
  // je ne mets volontairement que l'id dans la DB pour pouvoir changer tout le reste avec des MAJ des ficheirs json
  static final List<String> values = [
    id
  ];
  static const String id = "_id";
}


class CurrentStep extends ChangeNotifier{

  late int id;
  late String name;
  late MaterialColor color;
  late String homeText;


  static final CurrentStep _instance = CurrentStep._privateConstructor();

  CurrentStep._privateConstructor();

  factory CurrentStep() {
    return _instance;
  }

  late List<Resource> resources;
  late List<Quizz> quizzs;
  late List<IceBreaker> icebreakers;
  late List<PersonalChallenge> personalChallenges;
  late Survey survey;


  Future<void> changeStep(String stepFile) async{
    String data = await rootBundle.loadString(stepFile);
    final jsonResult = jsonDecode(data);
    id = jsonResult["id"];
    name = jsonResult["name"];
    color = generateMaterialColor(color: Color(int.parse(jsonResult["color"])));
    homeText = jsonResult["homeText"];
    resources = jsonResult["resources"].map((resource)=> Resource(resource["name"], resource["link"])).toList().cast<Resource>();
    personalChallenges = await ChallengeDatabase().readAllPersonalChallengesForStep(CurrentStep().id);
    //commonPersonalChallenges = jsonResult["personal_challenges"].map((challenge)=> PersonalChallenge(challenge)).toList().cast<PersonalChallenge>();
   // List teamChallengesString = jsonResult["team_challenges"];
    //TeamChallenges().teamChallengesList = teamChallengesString.map((challenge) => TeamChallenge(challenge, 0)).toList();
    TeamChallenges().teamChallengesList = await ChallengeDatabase().readAllTeamChallengesForStep(CurrentStep().id);
    quizzs = jsonResult["quizzs"].map((jsonQuizz)=> Quizz.fromJson(jsonQuizz)).toList().cast<Quizz>();
    icebreakers = jsonResult["icebreakers"].map((jsonIcebreaker)=>IceBreaker.fromJson(jsonIcebreaker)).toList().cast<IceBreaker>();
    survey = Survey(jsonResult["survey"].map((questionSurvey)=> QuestionSurvey.fromJson(questionSurvey)).toList().cast<QuestionSurvey>());
    notifyListeners();
  }

}