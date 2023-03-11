import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:mouvement_de_palier/step.dart';
import 'package:mouvement_de_palier/views/components/common_scaffold.dart';
import 'package:mouvement_de_palier/views/discussion_screen/animated_button.dart';
import 'package:mouvement_de_palier/views/game_screen/card_view.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
/*
class IceBreakerScreen extends StatelessWidget {
  IceBreakerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(_buildIceBreakerScreen);
  }
  var random = Random();

  StreamController<int> controller = StreamController<int>();

  Widget _buildIceBreakerScreen(BuildContext context){
    List<FortuneItem> items = const [
      FortuneItem(child: Text('Participant 1')),
      FortuneItem(child: Text('Participant 2')),
      FortuneItem(child:  Text('Participant 3')),
      FortuneItem(child: Text('Participant 4')),
      FortuneItem(child: Text('Participant 5')),
      FortuneItem(child:  Text('Participant 6')),];
    controller.add(random.nextInt(items.length));
    return Center(child: Column(
      children: [
        const SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(CurrentStep().icebreakers, style: TextStyle(fontSize: 30),),
        ),
        const SizedBox(height: 50,),
        Container(
        height: 300,
        child: FortuneWheel(
          selected: controller.stream,
            onFling: () {
            print("fling");
              controller.add(random.nextInt(items.length));
            },
          items: items
        ),
        ),
        const SizedBox(height: 50,),
        ElevatedButton(onPressed: (){}, child: Text("Suivant"))
      ],
    ));
  }
}
*/