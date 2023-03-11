import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mouvement_de_palier/db/challenge_db.dart';
import 'package:mouvement_de_palier/step.dart';
import 'package:mouvement_de_palier/views/components/common_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ResultsScreen extends StatefulWidget {
  ResultsScreen({Key? key}) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();

  bool sent = false;

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(_buildResultsScreen);
  }

  Widget _buildResultsScreen(BuildContext context){
    return Center(child: sent ? Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text("Merci d'avoir envoyé vos données :)", style: TextStyle(fontSize: 20),),
    ) : Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            children: [
              const Text("C'est l'heure du bilan !", style: TextStyle(fontSize: 20),),
              const SizedBox(height: 20,),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Entrez votre nom',
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez un nom svp !';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: () async {

                if (_formKey.currentState!.validate()) {
                  ChallengeDatabase().close();
                  String dirPath = await getDatabasesPath();
                  String _dbPath = dirPath + '/${ChallengeDatabase.dbName}';
                  final files = [
                    File(_dbPath)
                  ];
                  final directory = await getExternalStorageDirectory();
                  final zipFile = File(directory!.path + "/zip_file_path.zip");
                  await ZipFile.createFromFiles(
                      sourceDir: Directory(dirPath), files: files, zipFile: zipFile);
                   String data = await rootBundle.loadString("assets/config.json");
                   final jsonResult = jsonDecode(data);
                  final email = Email(
                    body: 'Voilà mes données !\n\n'
                        '${usernameController.text}',
                    subject: 'Export de données challenge mets ta poubelle au régime',
                    recipients:jsonResult['export_data_receivers'].cast<String>(),
                    //   cc: ['email'],
                    attachmentPaths: [zipFile.path],
                    isHTML: false,
                  );
                  await FlutterEmailSender.send(email);
                  setState(() {
                    sent = true;
                  });
                }
              },
                  child: Text("Exporter les données"))
            ]
        ),
      ),
    ));
  }
}
