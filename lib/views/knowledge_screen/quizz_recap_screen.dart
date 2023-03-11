import 'package:flutter/material.dart';
import 'package:mouvement_de_palier/model/quiz_state.dart';
import 'package:mouvement_de_palier/views/components/common_scaffold.dart';
import 'package:provider/provider.dart';

class RecapScreen extends StatelessWidget {
  int goodAnswers;
  int totalAnswers;

   RecapScreen(this.goodAnswers, this.totalAnswers);

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(_buildRecapScreen);
  }

  Widget _buildRecapScreen(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text:
          "Score: ",
          style: TextStyle(color: Colors.grey[600], fontSize: 30),
          children: [
            TextSpan(
              text: "$goodAnswers/$totalAnswers",
              style: TextStyle(color: Colors.grey[800], fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
