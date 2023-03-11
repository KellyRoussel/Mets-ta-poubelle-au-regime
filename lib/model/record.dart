const String recordTable = "record";

class RecordFields{
  static final List<String> values = [
    id, datetime, weight
  ];
  static const String id = "_id";
  static const String datetime = "datetime";
  static const String weight = "weight";
}

class Record{

  int? id;
  final DateTime date;
  double weight;

  Record(this.date, this.weight, {this.id});

  Map<String, dynamic> toJson() => {
    RecordFields.id: id,
  RecordFields.datetime: date.toIso8601String(),
  RecordFields.weight: weight
  };

  static Record fromJson(Map<String, Object?> json) => Record(
    DateTime.parse(json[RecordFields.datetime] as String),
    json[RecordFields.weight] as double,
    id: json[RecordFields.id] as int?
  );
}