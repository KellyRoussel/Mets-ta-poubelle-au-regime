import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mouvement_de_palier/model/record.dart';

class NewRecordWidget extends StatelessWidget {
  DateFormat formattedDate = DateFormat('dd/MM/yyyy');

  DateTime recordDate = DateTime.now();
  double? weight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete),
              Text('Nouvelle pesée ! '),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          //Text(formattedDate.format(recordDate)),
          DatePicker(
            DateTime.now().subtract(Duration(days: 4)),
            initialSelectedDate: recordDate,
            selectionColor: Colors.black,
            selectedTextColor: Colors.white,
            locale: 'fr_FR', 
              daysCount:5,
            onDateChange: (date) {
              recordDate = date;
            },
          ),
          const SizedBox(
            height: 20.0,
          ),
          Container(
            width: 100,
            child: TextField(

              style: TextStyle(fontSize: 20),
                autofocus:true,
              onChanged: (text) {
                print("changed");
                weight = double.parse(text);
              },
              onSubmitted: (text){
                print(weight);
                Record? record = weight == null ? null : Record(recordDate, weight!);
                Navigator.pop(context, record);
              },
              decoration: const InputDecoration(
                  labelText: "Poids",
                border: OutlineInputBorder(),),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
          ),

        ],
      ),
    );
  }
}
