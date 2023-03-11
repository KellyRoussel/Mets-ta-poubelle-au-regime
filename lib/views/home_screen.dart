import 'package:flutter/material.dart';
import 'package:mouvement_de_palier/model/shared_preferences.dart';
import 'package:mouvement_de_palier/step.dart';
import 'package:mouvement_de_palier/views/components/common_scaffold.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(AppSharedPreferences.sharedPreferencesInstance.getBool(AppSharedPreferences.firstOpeningAppKey) ?? true) {
      Future.delayed(Duration.zero, () => _dialogBuilder(context));
    }
    return CommonScaffold(_buildHomeScreen);
  }

  Widget _buildHomeScreen(BuildContext context){
    return Center(child: Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          //Image.asset("assets/logo.jpg"),
          Text(CurrentStep().name, style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
          SizedBox(height: 20,),
          Text(CurrentStep().homeText + "\n", style: TextStyle(fontSize: 18),textAlign: TextAlign.center,)
        ]..addAll(CurrentStep().resources.map((resource) =>
            Container(
              margin: EdgeInsets.all(20),
              child: InkWell(child: Text(resource.name,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 15,
                decoration: TextDecoration.underline,),),
                onTap: () => launchUrlString(resource.link),
        ),
            )))..addAll(
            [Container(
                margin: EdgeInsets.all(20),
                child: InkWell(child: Text("Lien à suivre pour s’inscrire aux conférences et ateliers du défi Mets ta poubelle au régime: ",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    decoration: TextDecoration.underline,),),
                  onTap: () => launchUrlString("https://linktr.ee/conferences.et.ateliers"),
                ),
              ),
              Container( margin: EdgeInsets.all(20), child: Text("Nous suivre sur les réseaux sociaux: ")),
              Container(
                margin: EdgeInsets.all(20),
                child: InkWell(child: Text("Facebook",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    decoration: TextDecoration.underline,),),
                  onTap: () => launchUrlString("https://www.facebook.com/mouvementdepalier"),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: InkWell(child: Text("Instagram",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    decoration: TextDecoration.underline,),),
                  onTap: () => launchUrlString("https://www.instagram.com/mouvementdepalier/"),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: InkWell(child: Text("Newsletter",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    decoration: TextDecoration.underline,),),
                  onTap: () => launchUrlString("https://www.mouvementdepalier.fr/newsletter/"),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: InkWell(child: Text("Site web",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    decoration: TextDecoration.underline,),),
                  onTap: () => launchUrlString("https://www.mouvementdepalier.fr/"),
                ),
              )
            ])
      ),
    ));
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {

        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          elevation: 3,
          child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Hey ! 👋\n\nBienvenue sur l'application du défi Mets ta poubelle au régime.\n\n"
                      "Les données de cette application seront récupérées à l'export dans l'onglet 'bilan'.\n\n"
                      "Bon défi !",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,),
                  TextButton(onPressed: ()async{
                    await AppSharedPreferences.sharedPreferencesInstance.setBool(AppSharedPreferences.firstOpeningAppKey, false);
                    Navigator.pop(context);
                    },
                      child: Text("OK",style: TextStyle(fontSize: 20),))
                ],
              )
          ),
        );
      },
    );
  }
}

