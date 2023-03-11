import 'package:flutter/material.dart';

class KnowledgeCard extends StatelessWidget {
  Color color;
  String topic;
  KnowledgeCard({required this.topic, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: 300,
        child: InkWell(
          child: Card(elevation: 3, color: color,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                Text(topic)
              ],),
            ),),
          onTap: (){
            print("tap"); // todo : on tap a card / topic
          },
        ));
  }
}
