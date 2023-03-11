import 'package:flutter/material.dart';
import 'package:mouvement_de_palier/db/challenge_db.dart';
import 'package:provider/provider.dart';

const String teamChallengeTable = "team_challenge";

class TeamChallengeFields{
  static final List<String> values = [
    id, text, success, stepId
  ];
  static const String id = "_id";
  static const String text = "text";
  static const String success = "success";
  static const String stepId = "stepId";
}

class TeamChallenge{
  int? id;
  String text;
  //int nTeamsDone;
  late bool _success;
  int stepId;
  TeamChallenge(this.text, this.stepId,
      //this.nTeamsDone
      {this.id,
        bool success=false}
      ){
    _success =success;
  }

  bool get success => _success;

  set success(value){
    _success = !_success;
    ChallengeDatabase().updateTeamChallenge(this);
    TeamChallenges().notifyListeners();
  }

  Map<String, dynamic> toJson() => {
    TeamChallengeFields.id: id,
    TeamChallengeFields.text: text,
    TeamChallengeFields.success: success.toString(),
    TeamChallengeFields.stepId: stepId
  };

  static TeamChallenge fromJson(Map<String, Object?> json) => TeamChallenge(
      json[TeamChallengeFields.text] as String,
      json[TeamChallengeFields.stepId] as int,
      success: (json[TeamChallengeFields.success] as String).toLowerCase() == 'true',
      id: json[TeamChallengeFields.id] as int?
  );

}

class TeamChallenges extends ChangeNotifier{

  static final TeamChallenges _instance = TeamChallenges._privateConstructor();

  TeamChallenges._privateConstructor();

  factory TeamChallenges() {
    return _instance;
  }

  int get nDoneChallenges => doneChallenges.length;

  int get nRemainingChallenges => remainingChallenges.length;

  List<TeamChallenge> get doneChallenges => teamChallengesList.where((element) => element.success).toList();
  List<TeamChallenge> get remainingChallenges => teamChallengesList.where((element) => !element.success).toList();


  late List<TeamChallenge> teamChallengesList;


}