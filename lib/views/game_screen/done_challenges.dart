import 'package:flutter/material.dart';
import 'package:mouvement_de_palier/model/team_challenge.dart';
import 'package:mouvement_de_palier/views/components/common_scaffold.dart';
import 'package:mouvement_de_palier/views/game_screen/card_view.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

// voir le nb d'équipes qui ont réussi le défi
class DoneChallengesScreen extends StatefulWidget {
  List<TeamChallenge> teamChallenges = TeamChallenges().doneChallenges;


  @override
  State<DoneChallengesScreen> createState() => _DoneChallengesScreenState();
}

class _DoneChallengesScreenState extends State<DoneChallengesScreen> {

  int nTeams = 20;

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(_buildDoneChallengesScreen);
  }

  Widget _buildDoneChallengesScreen(BuildContext context) {

    return Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("${widget.teamChallenges.length} validés", style: TextStyle(fontSize: 30),),
              ),
              Wrap(
                children: widget.teamChallenges.map((challenge) =>
        GestureDetector(
            onTap: () async {
              await _dialogBuilder(context, challenge, nTeams);
              if(!challenge.success){
                setState(() {
                  widget.teamChallenges.remove(challenge);
                });
              }

            },
            child: ChallengeDoneWidget(challenge, nTeams))).toList(),),
            ],
          ),
        );

  }
}

class ChallengeDoneWidget extends StatelessWidget {

  TeamChallenge challenge;
  int nTeams;

  ChallengeDoneWidget(this.challenge, this.nTeams);


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 3,
      child: Container(
        color: Theme.of(context).primaryColor.withAlpha(100),
        width: (width- 50)/3,
        height: 100,
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.amber,),
                //Text("${challenge.nTeamsDone}/$nTeams"),
                /*Text.rich(TextSpan(
                  text: challenge.nTeamsDone.toString(),
                  style: TextStyle(color: Colors.grey[600], fontSize: 20),
                  children: [
                    TextSpan(
                      text: "/$nTeams",
                      style: TextStyle(color: Colors.grey[800], fontSize: 15),
                    ),
                  ],
                ),
                )*/
              ],
            ),
            const SizedBox(height: 5,),
            Text(challenge.text, overflow: TextOverflow.ellipsis, maxLines: 3, ),
          ],
        ),
      ),
    );
  }
}

Future<void> _dialogBuilder(BuildContext context, TeamChallenge challenge, int nTeams) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {

      return Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        elevation: 3,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, color: Colors.amber,),

                  /*Text.rich(TextSpan(
                    text: challenge.nTeamsDone.toString(),
                    style: TextStyle(color: Colors.grey[600], fontSize: 20),
                    children: [
                      TextSpan(
                        text: "/$nTeams",
                        style: TextStyle(color: Colors.grey[800], fontSize: 15),
                      ),
                    ],
                  ),)*/
                ],
              ),
            const SizedBox(height: 20,),
            Text(challenge.text, style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),),
              const SizedBox(height: 20,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: (){
                  challenge.success = false;
                  Navigator.pop(context);},
                  child: Text("Pas réussi", style: TextStyle(color: Colors.red),)),
              TextButton(onPressed: (){Navigator.pop(context);}, child: Text("OK"))],)
          ],),
        ),
          );
    },
  );
}