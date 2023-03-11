import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/gesture_flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:mouvement_de_palier/routes.dart';
import 'package:mouvement_de_palier/step.dart';
import 'package:mouvement_de_palier/views/components/common_scaffold.dart';
import 'package:mouvement_de_palier/views/discussion_screen/icebreaker_card.dart';


// todo : ajouter 1 section par étape du défi avec + de contenu:
// 1. une question brise glace
// 2. roue des participants
// 3. autres idées pour relancer la discussion
class DiscussionScreen extends StatelessWidget {
  DiscussionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(_buildDiscussionScreen);
  }
  var random = Random();



  Widget _buildDiscussionScreen(BuildContext context){

    return Container(
        height: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.all(10),
             child:
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Icon(Icons.keyboard_double_arrow_down),
                    Text("Balayez vers le bas pour retourner les cartes")
                  ],),
                )),
              ]..addAll(CurrentStep().icebreakers.map((icebreaker) => IcebreakerCard(icebreaker))),

        ));
  }
}
