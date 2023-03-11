import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mouvement_de_palier/model/team_challenge.dart';
import 'package:mouvement_de_palier/routes.dart';
import 'package:mouvement_de_palier/step.dart';
import 'package:mouvement_de_palier/views/data_screen/data_screen.dart';
import 'package:mouvement_de_palier/views/discussion_screen/discussion_screen.dart';
import 'package:mouvement_de_palier/views/discussion_screen/icebreaker_screen.dart';
import 'package:mouvement_de_palier/views/game_screen/done_challenges.dart';
import 'package:mouvement_de_palier/views/game_screen/game_screen.dart';
import 'package:mouvement_de_palier/views/game_screen/remaining_challenges.dart';
import 'package:mouvement_de_palier/views/home_screen.dart';
import 'package:mouvement_de_palier/views/knowledge_screen/knowledge_screen.dart';
import 'package:mouvement_de_palier/views/knowledge_screen/question_screen.dart';
import 'package:mouvement_de_palier/views/knowledge_screen/quizz_screen.dart';
import 'package:mouvement_de_palier/views/results_screen/results_screen.dart';
import 'package:mouvement_de_palier/views/survey_screen/survey_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CurrentStep().changeStep("assets/step1.json");
  AppSharedPreferences.sharedPreferencesInstance = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => CurrentStep(),
      child: Consumer<CurrentStep>(
        builder: (context, CurrentStep step, Widget) {
          return ChangeNotifierProvider(
            create: (context) => TeamChallenges(),
            child: MaterialApp(
              title: 'Mouvement de Palier App',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: CurrentStep().color,
                  primaryColorLight : CurrentStep().color[200]
              ),
              initialRoute: Routes.home,
              routes: {
                Routes.home: (context) => HomeScreen(),
                Routes.data: (context) => DataScreen(),
                Routes.game: (context) => GameScreen(),
                Routes.doneChallenges: (context) => DoneChallengesScreen(),
                Routes.remainingChallenges: (context) => RemainingChallengesScreen(),
                Routes.discussion: (context) => DiscussionScreen(),
              //  Routes.icebreaker: (context) => IceBreakerScreen(),
                Routes.knowledge: (context) => QuizzScreen(),
                Routes.results: (context)=> ResultsScreen(),
                Routes.survey: (context)=> SurveyScreen()
              },
            ),
          );
        }
      ),
    );
  }



}

