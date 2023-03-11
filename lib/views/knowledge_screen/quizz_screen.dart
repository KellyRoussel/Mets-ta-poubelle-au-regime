import 'package:flutter/material.dart';
import 'package:mouvement_de_palier/model/quiz_state.dart';
import 'package:mouvement_de_palier/step.dart';
import 'package:mouvement_de_palier/views/components/common_scaffold.dart';
import 'package:mouvement_de_palier/views/knowledge_screen/question_screen.dart';
import 'package:provider/provider.dart';


class QuizzScreen extends StatelessWidget {

  List<String> categories = CurrentStep().quizzs.map((e) => e.subject).toList();
  late String selectedCategory;

  QuizzScreen(){
    selectedCategory = categories[0];
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(_buildQuizzScreen);
  }

  Widget _buildQuizzScreen(BuildContext context){
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28.0, vertical: 56.0),
                      child:  Text(
                        'QUIZZ',
                        style: TextStyle(
                          fontSize: 46.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                          letterSpacing: 4.0,
                          shadows: [
                            Shadow(
                              blurRadius: 8.0,
                              color: Theme.of(context).primaryColor,
                              offset: Offset(3.0, 4.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Text(
                      'Choisis un thème et teste tes connaissances !',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CategorySelector(categories)

                  ],
                ),



      );
  }
}

class CategorySelector extends StatefulWidget {

  late List<String> categories;
  late int selectedCategory;

   CategorySelector(this.categories){
     selectedCategory = 0;
   }

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<int>(
          isExpanded: true,
          value: widget.selectedCategory,
          onChanged: (value){
            setState(() {
              widget.selectedCategory = value!;
            });
          },
          items: List.generate(CurrentStep().quizzs.length, (index) => DropdownMenuItem<int>(
            value: index,
            child: Text(
              CurrentStep().quizzs[index].subject,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),)

        ),
        ElevatedButton(onPressed: (){
          Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) =>  ChangeNotifierProvider(
                create: (context) => QuizzState(),
                child: QuestionScreen(CurrentStep().quizzs[widget.selectedCategory]))),);
        }, child: Text("Jouer !"))
      ],
    );
  }
}
