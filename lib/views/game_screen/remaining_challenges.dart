import 'package:flutter/material.dart';
import 'package:mouvement_de_palier/model/team_challenge.dart';
import 'package:mouvement_de_palier/views/components/common_scaffold.dart';
import 'package:mouvement_de_palier/views/game_screen/card_view.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

class RemainingChallengesScreen extends StatefulWidget {
  List<TeamChallenge> teamChallenges = TeamChallenges().remainingChallenges;


  @override
  State<RemainingChallengesScreen> createState() => _RemainingChallengesScreenState();
}

class _RemainingChallengesScreenState extends State<RemainingChallengesScreen> {


  @override
  Widget build(BuildContext context) {
    return CommonScaffold(_buildRemainingChallengesScreen);
  }

  Widget _buildRemainingChallengesScreen(BuildContext context) {

    return Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("${widget.teamChallenges.length} restants", style: TextStyle(fontSize: 30),),
              ),
              Wrap(
                children: widget.teamChallenges.map((challenge) =>
        GestureDetector(
            onTap: () async {
              await _dialogBuilder(context, challenge);
              if(challenge.success){
                setState(() {
                  widget.teamChallenges.remove(challenge);
                });
              }

            },
            child: ChallengeRemainingWidget(challenge))).toList(),),
            ],
          ),
        );

  }
}

class ChallengeRemainingWidget extends StatelessWidget {

  TeamChallenge challenge;


  ChallengeRemainingWidget(this.challenge,);


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
        child: Text(challenge.text, overflow: TextOverflow.ellipsis, maxLines: 3, ),
      ),
    );
  }
}

Future<void> _dialogBuilder(BuildContext context, TeamChallenge challenge) {
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
            Text(challenge.text, style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),),
              const SizedBox(height: 20,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: (){
                  challenge.success = true;
                  Navigator.pop(context);},
                  child: Text("Réussi", style: TextStyle(color: Colors.green),)),
              TextButton(onPressed: (){Navigator.pop(context);}, child: Text("OK"))],)
          ],),
        ),
          );
    },
  );
}