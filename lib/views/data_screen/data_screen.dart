import 'package:flutter/material.dart';
import 'package:mouvement_de_palier/db/challenge_db.dart';
import 'package:mouvement_de_palier/model/personal_challenge.dart';
import 'package:mouvement_de_palier/model/record.dart';
import 'package:mouvement_de_palier/step.dart';
import 'package:mouvement_de_palier/views/components/common_scaffold.dart';
import 'package:mouvement_de_palier/views/data_screen/new_record_form.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DataScreen extends StatefulWidget {
  DataScreen({Key? key}) : super(key: key);

  @override
  State<DataScreen> createState() => _DataScreenState();
}

// todo : plusieurs courbes pour les différentes poubelles
class _DataScreenState extends State<DataScreen> {

  late List<Record> records;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(_buildDataScreen);
  }

  @override
  void initState() {
    print("initState");
    super.initState();
    _loadRecords();
  }

  Future _loadRecords() async{
    setState(() {
      isLoading = true;
    });
    records = await ChallengeDatabase().readAllRecords();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    ChallengeDatabase().close();
    super.dispose();
  }

 // List<PersonalChallenge> challenges = CurrentStep().commonPersonalChallenges;


  Widget _buildDataScreen(BuildContext context){
    return isLoading ? Center(child: CircularProgressIndicator()) : Column(
      children: [
        Center(
            child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(),
            // Chart title
            title: ChartTitle(text: 'Poids des déchets (kg)'),
            // Enable tooltip
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries<Record, DateTime>>[
            LineSeries<Record, DateTime>(
            dataSource: records,
            xValueMapper: (Record record, _) => record.date,
            yValueMapper: (Record record, _) => record.weight,
            )])),
        ElevatedButton(onPressed: () async {
          await newRecord();
        }, child: Text("Nouvelle pesée")),
      ]..addAll(CurrentStep().personalChallenges.map((challenge) => PersonalChallengeWidget(challenge)))
        ..add(ElevatedButton(onPressed: () async {
        PersonalChallenge? newChallenge = await _dialogBuilder(context);
        if(newChallenge != null){
          await ChallengeDatabase().createPersonalChallenge(newChallenge);
          setState(() {
            CurrentStep().personalChallenges.add(newChallenge);
          });
        }
      }, child: Text("Nouveau défi"))),
    );
  }

  Future<void> newRecord() async {
    Record? record = await showModalBottomSheet<Record>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
              //height: 200,
              child: NewRecordWidget()),
        );
      },
    );

    if(record != null){
      await ChallengeDatabase().createRecord(record);
      //records.forEach((element) {RecordsDatabase().delete(element.id!);});
      setState(() {
        records.add(record);
      });
    }
  }
}

class PersonalChallengeWidget extends StatefulWidget {
  PersonalChallenge challenge;

  PersonalChallengeWidget(this.challenge);

  @override
  State<PersonalChallengeWidget> createState() => _PersonalChallengeWidgetState();
}

class _PersonalChallengeWidgetState extends State<PersonalChallengeWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(icon: Icon(Icons.star),
        color: widget.challenge.validated ? Colors.amber : Colors.grey,
        onPressed: () async { setState(() {
          widget.challenge.validated = !widget.challenge.validated;
        });
        await ChallengeDatabase().updatePersonalChallenge(widget.challenge);
        },),
      title: Text(widget.challenge.text),
    );
  }
}

Future<PersonalChallenge?> _dialogBuilder(BuildContext context) {
  String challengeText ="";
  return showDialog<PersonalChallenge>(
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
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: TextStyle(fontSize: 20),
                autofocus:true,
                onChanged: (text) {
                  challengeText = text;
                },
                onSubmitted: (text){
                 //todo
                 // Navigator.pop(context);
                },
                decoration: const InputDecoration(
                  labelText: "Nouveau défi",
                  border: OutlineInputBorder(),),

              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: (){
                        Navigator.pop(context);},
                      child: Text("Annuler",)),
                  ElevatedButton(onPressed: (){
                    PersonalChallenge newChallenge = PersonalChallenge(challengeText, CurrentStep().id);
                    Navigator.pop(context, newChallenge);},
                      child: Text("Enregistrer"))],)
            ],),
        ),
      );
    },
  );
}

