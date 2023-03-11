import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mouvement_de_palier/model/survey.dart';
import 'package:mouvement_de_palier/step.dart';
import 'package:mouvement_de_palier/views/components/common_scaffold.dart';
import 'package:path_provider/path_provider.dart';

class SurveyScreen extends StatefulWidget {
  SurveyScreen({Key? key}) : super(key: key);

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();

  bool sent = false;

  @override
  Widget build(BuildContext context) {

    return CommonScaffold(_buildSurveyScreen);
  }

  Widget _buildSurveyScreen(BuildContext context){
   // List<AdaptedWidget> adaptedWidgetsList =  CurrentStep().survey.map((question) => adaptedWidget(question)).toList();
    return Center(child: sent ? Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text("Merci d'avoir répondu :)", style: TextStyle(fontSize: 20),),
    ) :  Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            children: [ TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ton nom et ton prénom',
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Entre ton nom stp ! :)';
                }
                return null;
              },
            ),]..addAll(CurrentStep().survey.questions.map((questionSurvey){
              String compulsory = questionSurvey.compulsory ? "*" : "";
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(questionSurvey.question + compulsory, style: TextStyle(fontSize: 20),),
                  const SizedBox(height: 20,),
                  questionSurvey.widget,
                  const SizedBox(height: 30,),
                ],
              ) as Widget;
            }).toList())..add(ElevatedButton(onPressed: () async {
              if(_formKey.currentState!.validate()){
                final directory = await getExternalStorageDirectory();
                final surveyAnswerFile = File(directory!.path + "/survey.json");
                surveyAnswerFile.writeAsStringSync(json.encode(CurrentStep().survey.toJson()));
                String data = await rootBundle.loadString("assets/config.json");
                final jsonResult = jsonDecode(data);
                final email = Email(
                  body: "Réponses au questionnaire de l'étape ${CurrentStep().name}!\n\n ${usernameController.text}",
                  subject: 'Export de données challenge mets ta poubelle au régime',
                  recipients:jsonResult['export_data_receivers'].cast<String>(),
                  //   cc: ['email'],
                  attachmentPaths: [surveyAnswerFile.path],
                  isHTML: false,
                );
                await FlutterEmailSender.send(email);
                setState(() {
                  sent = true;
                });
              }

            }, child: Text("Valider")))

        ),
      ),
    )
    )
    ;
  }
}
