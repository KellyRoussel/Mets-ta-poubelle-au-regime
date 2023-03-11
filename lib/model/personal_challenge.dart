const String personalChallengeTable = "personal_challenge";

class PersonalChallengeFields{
  static final List<String> values = [
    id, text, validated, stepId
  ];
  static const String id = "_id";
  static const String text = "text";
  static const String validated = "validated";
  static const String stepId = "stepId";
}

class PersonalChallenge{

  int? id;
  String text;
  bool validated;
  int stepId;
  PersonalChallenge(this.text, this.stepId, {this.validated=false, this.id});

  Map<String, dynamic> toJson() => {
    PersonalChallengeFields.id: id,
    PersonalChallengeFields.text: text,
    PersonalChallengeFields.validated: validated.toString(),
    PersonalChallengeFields.stepId: stepId
  };

  static PersonalChallenge fromJson(Map<String, Object?> json) => PersonalChallenge(
      json[PersonalChallengeFields.text] as String,
      json[PersonalChallengeFields.stepId] as int,
      validated: (json[PersonalChallengeFields.validated] as String).toLowerCase() == 'true',
      id: json[PersonalChallengeFields.id] as int?
  );
}