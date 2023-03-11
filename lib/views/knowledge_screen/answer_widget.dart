import 'package:flutter/material.dart';
import 'package:mouvement_de_palier/model/quizz.dart';
import 'package:mouvement_de_palier/model/quiz_state.dart';

class AnswerWidget extends StatelessWidget {
  Answer answer;
  QuizzState quizzState;
  AnswerWidget(this.answer, this.quizzState);
  Color get answeredColor => answer.valid ? Colors.green : Colors.red;
  Color get backgroundColor => answer.selected ? answeredColor : Colors.transparent;

  @override
  Widget build(BuildContext context) {

    return MaterialButton(
      onPressed: quizzState.answered ? null : () {
        quizzState.answered=true;
        answer.selected = true;
        if(answer.valid){
          quizzState.goodAnswers++;
        }
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            border: Border.all(
              width:2,
              color: quizzState.answered ? answeredColor.withOpacity(0.7) : Colors.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: backgroundColor
        ),
        child: Text(answer.text, style: TextStyle(fontSize: 20,
            color: (quizzState.answered &&  answer.valid) ? answer.selected ? Colors.white : Colors.green : Colors.black),),
      ),
    );
  }
}