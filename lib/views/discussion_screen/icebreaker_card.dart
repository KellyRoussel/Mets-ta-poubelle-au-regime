import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/gesture_flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:mouvement_de_palier/model/icebreaker.dart';

class IcebreakerCard extends StatelessWidget {
  IceBreaker iceBreaker;
  IcebreakerCard(this.iceBreaker);

  final controller = GestureFlipCardController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(

        margin: EdgeInsets.all(10),
        child: GestureFlipCard(
          animationDuration: const Duration(milliseconds: 300),
          axis: FlipAxis.horizontal,
          controller:controller, // used to ccontrol the Gesture flip programmatically
          enableController : false, // if [True] if you need flip the card using programmatically
          frontWidget: Center(
            child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(iceBreaker.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    Text(iceBreaker.summary,
                      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.people_alt),
                            Text(iceBreaker.rangeNParticipants)
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.timer),
                            Text(iceBreaker.rangeNMinutes)
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )),

            ),
          ),
          backWidget: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: Container(
              margin: EdgeInsets.all(20),
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:  EdgeInsets.all(20),

                child: Center(child: SingleChildScrollView(child: Text(iceBreaker.description,))))),
          ),
        ),
      ),
    );
  }
}
