import 'package:flutter/material.dart';
import 'package:mouvement_de_palier/model/team_challenge.dart';
import 'package:mouvement_de_palier/routes.dart';
import 'package:mouvement_de_palier/views/components/common_scaffold.dart';
import 'package:mouvement_de_palier/views/game_screen/card_view.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
// todo : voir les cartes faites et pas faites
// voir le nb d'équipes qui ont réussi le défi
class GameScreen extends StatelessWidget {
  GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(_buildGameScreen);
  }

  SwipeableCardSectionController _cardController = SwipeableCardSectionController();
  int counter = 3;
  List<TeamChallenge> challenges = TeamChallenges().remainingChallenges;



  Widget _buildGameScreen(BuildContext context){

    return Center(child: Container(
        height: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<TeamChallenges>(
                builder: (context, TeamChallenges teamChallenges, Widget) {
                  return
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(onPressed: (){
                          Navigator.of(context).pushNamed(Routes.remainingChallenges);
                        }, child: Text("${teamChallenges.nRemainingChallenges} Restants")),
                        MaterialButton(onPressed: (){
                          Navigator.of(context).pushNamed(Routes.doneChallenges);
                        }, child: Text("${teamChallenges.nDoneChallenges} Validés"),),
                      ],);}),
            //const SizedBox(height: 50,),
            SwipeableCardsSection(
              cardController: _cardController,
              context: context,
              //add the first 3 cards
              items: List.generate(3, (index){
                if(challenges.length > index){
                  return CardView(text: challenges[index].text,);
                }else{
                  return Container();
                }
              }),
              onCardSwiped: (dir, index, widget) {
                //Add the next card
                if (counter < challenges.length) {
                  _cardController.addItem(CardView(text: challenges[counter].text));
                  counter++;
                }

                if (dir == Direction.left) {
                  print('onDisliked ${(widget as CardView).text} $index');
                  print("THIS IS CHALLENGE : ${challenges[index].text}");
                  //challenges[index].success = false;
                } else if (dir == Direction.right) {
                  print('onLiked ${(widget as CardView).text} $index');
                  challenges[index].success = true;
                }
              },
              enableSwipeUp: false,
              enableSwipeDown: false,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: "left",
                    child: Icon(Icons.chevron_left),
                    onPressed: () => _cardController.triggerSwipeLeft(),
                  ),
                  FloatingActionButton(
                    heroTag: "right",
                    child: Icon(Icons.chevron_right),
                    onPressed: () => _cardController.triggerSwipeRight(),
                  ),
                 /* FloatingActionButton(
                    heroTag: "up",
                    child: Icon(Icons.arrow_upward),
                    onPressed: () => _cardController.triggerSwipeUp(),
                  ),
                  FloatingActionButton(
                    heroTag: "down",
                    child: Icon(Icons.arrow_downward),
                    onPressed: () => _cardController.triggerSwipeDown(),
                  ),*/
                ],
              ),
            )
          ],
        )

    ));
  }
}
