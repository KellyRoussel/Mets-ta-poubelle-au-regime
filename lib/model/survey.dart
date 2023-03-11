import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Survey{
  List<QuestionSurvey> questions;

  Survey(this.questions);

  List<Map<String, dynamic>> toJson(){
    return []..addAll(questions.map((e) => e.toJson()));
  }
}

class QuestionSurvey{

  late String type;
  late String question;
  late bool compulsory;
  bool? multipleAnswers;
  List<String>? possibleAnswers;

  List<String> answers = [];
  late Widget widget;

  QuestionSurvey.fromJson(Map<String, dynamic> json){
    type = json["type"];
    question = json["question"];
    compulsory = json["compulsory"];
    possibleAnswers = json.containsKey('answers') ? json["answers"].cast<String>() : null;
    multipleAnswers = json.containsKey('multiple_answers') ? json["multiple_answers"] : null;
    widget = adaptedWidget();
  }

  Map<String, dynamic> toJson(){
    return {
      "question": question,
      "answers": answers
    };
  }

  Widget adaptedWidget(){
    if(type == "open"){
      TextEditingController controller = TextEditingController();
      return TextFormField(
        controller: controller,
        onChanged: (value){
          if(answers.isEmpty){
            answers.add(value);
          }else{
            answers[0] = value;
          }
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        maxLines: 5,
        validator:(value) {
          return (compulsory && (value == null || value.isEmpty))
              ? "Veuillez répondre à cette question"
              : null;
        },
      );

    }else{
      if(multipleAnswers!){
        return  Column(
            children: possibleAnswers!.map((answer) =>
              MultipleAnswer(answer, (bool value) => value ? answers.add(answer) : answers.remove(answer))
        ).toList());
      }else{
        //radio button
        answers.add(possibleAnswers![0]);
        return  RadioGroup(possibleAnswers!, (value)=>answers[0]=value);
      }
    }
  }

}

class MultipleAnswer extends StatefulWidget {
  String answer;
  bool isChecked = false;
  Function onChanged;
  MultipleAnswer(this.answer, this.onChanged);

  @override
  State<MultipleAnswer> createState() => _MultipleAnswerState();
}

class _MultipleAnswerState extends State<MultipleAnswer> {
  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Checkbox(value: widget.isChecked,
          onChanged: (bool? value){setState(() {
            widget.isChecked = value!;
            widget.onChanged(value);
          });},

        ),
        Text(widget.answer)
      ],
    );
  }
}

class RadioGroup extends StatefulWidget {
  List<String> answers;
  late String answer;
  Function onChanged;
  RadioGroup(this.answers, this.onChanged){
    answer=answers[0];
  }

  @override
  State<RadioGroup> createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {

  @override
  Widget build(BuildContext context) {
    return Column(
        children: widget.answers.map((a) =>
            RadioListTile(
              title: Text(a),
              value: a,
              groupValue: widget.answer,
              onChanged: (String? value){
                setState(() {
                  widget.answer = value!;
                  widget.onChanged(value);
                });
              },
            ),).toList()
    );
  }
}