import 'package:flutter/material.dart';
import 'package:mouvement_de_palier/model/quizz.dart';
import 'package:mouvement_de_palier/model/quiz_state.dart';
import 'package:mouvement_de_palier/views/components/common_scaffold.dart';
import 'package:mouvement_de_palier/views/knowledge_screen/answer_widget.dart';
import 'package:mouvement_de_palier/views/knowledge_screen/quizz_recap_screen.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class QuestionScreen extends StatelessWidget {

  Quizz quizz;
  QuestionScreen(this.quizz);

  @override
  Widget build(BuildContext context) {

    return CommonScaffold(_buildQuestionScreen);
  }

  Widget _buildQuestionScreen(BuildContext context){
    var quizzState = Provider.of<QuizzState>(context);
    Question question = quizz.questions[quizzState.index];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(height: 10,),
          LinearPercentIndicator(
            barRadius: Radius.circular(5),
            lineHeight: 20.0,
            percent: (quizzState.index+1)/quizz.questions.length,
            backgroundColor: Colors.grey[300],
            progressColor: Colors.blue,
          ),
          SizedBox(height: 20,),
          Text.rich(
            TextSpan(
              text:
              "Question ${quizzState.index+1}",
              style: TextStyle(color: Colors.grey[600], fontSize: 30),
              children: [
                TextSpan(
                  text: "/${quizz.questions.length}",
                  style: TextStyle(color: Colors.grey[800], fontSize: 20),
                ),
              ],
            ),
          ),
          SizedBox(height: 30,),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical:20),
                child: Column(children: [
                Text(question.question, style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                SizedBox(height: 40,),
                Column(children: question.answers.map((answer)=> AnswerWidget(answer, quizzState)).toList(),),

                  Visibility(
                    visible: quizzState.answered,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(child: Text(question.explanation ?? "")),
                          SizedBox(width: 5,),
                          IconButton(onPressed: (){
                            if (quizzState.index+1==quizz.questions.length) {
                              Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) =>
                                    RecapScreen(quizzState.goodAnswers, quizz.questions.length)),);
                            }else{
                              quizzState.index++;
                            }
                          }, icon: Icon(Icons.navigate_next_sharp, size: 50,))
                        ],
                      ),
                    ),
                  ),
              ]
                ,),
              ),
            ),
          ),

        ],
      ),
    );
  }
}


