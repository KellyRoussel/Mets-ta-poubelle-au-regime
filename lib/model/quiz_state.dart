import 'package:flutter/material.dart';

class QuizzState with ChangeNotifier{

  int? _selectedAnswer;
  int _index = 0;
  bool _answered = false;
  int goodAnswers = 0;

  int? get selectedAnswer => _selectedAnswer;
  int get index => _index;
  bool get answered => _answered;

  set selected(int newValue) {
    _selectedAnswer = newValue;
    notifyListeners();
  }

  set index(int newValue) {
    _index = newValue;
    _answered = false;
    notifyListeners();
  }

  set answered(bool newAnswer){
    _answered = newAnswer;
    notifyListeners();
  }

}