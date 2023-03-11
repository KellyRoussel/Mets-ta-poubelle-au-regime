class Question{
  late String question;
  late List<Answer> answers;
  String? explanation;


  Question.fromJson(Map<String, dynamic> json){
    question = json["question"];
    explanation = json.containsKey("explanation") ?  json["explanation"] : null;
    answers = json["answers"].map((jsonAnswer)=> Answer.fromJson(jsonAnswer)).toList().cast<Answer>();
  }
}

class Answer{
  late String text;
  late bool valid;
  bool selected = false;

  Answer.fromJson(Map<String, dynamic> json){
    text = json["answer"];
    valid = json["valid"] as bool;
  }
}

class Quizz{
  late List<Question> questions;
  late String subject;


  Quizz.fromJson(Map<String, dynamic> json){
    subject = json["subject"];
    questions = json["questions"].map((jsonAnswer)=> Question.fromJson(jsonAnswer)).toList().cast<Question>();
  }
}