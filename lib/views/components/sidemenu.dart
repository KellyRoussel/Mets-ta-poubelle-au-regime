import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mouvement_de_palier/routes.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
         DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Image.asset("assets/logo.jpg"),
        ),
        ListTile(
          title: const Text('Accueil'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(Routes.home); // Todo : changer les transitions moches : https://stackoverflow.com/questions/56792479/flutter-animate-transition-to-named-route
          },
        ),
        Visibility(
          visible: !kIsWeb,
          child: ListTile(
            title: const Text('Suivi du poids'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(Routes.data);
            },
          ),
        ),
        ListTile(
          title: const Text("Challenges d'équipes"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(Routes.game);
          },
        ),
        ListTile(
          title: const Text("Animation d'équipes"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(Routes.discussion);
          },
        ),
        ListTile(
          title: const Text('Quizz'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(Routes.knowledge);
          },
        ),
        ListTile(
          title: const Text('Bilan'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(Routes.results);
          },
        ),
        ListTile(
          title: const Text('Feedback'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(Routes.survey);
          },
        ),
      ],
    );
  }
}
