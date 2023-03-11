class IceBreaker{
  late String title;
  late String summary;
  late String description;
  late String rangeNParticipants;
  late String rangeNMinutes;


  IceBreaker.fromJson(Map<String, dynamic> json){
   title = json["title"];
   summary = json["summary"];
   description = json["description"];
   rangeNParticipants = json["range_n_participants"];
   rangeNMinutes = json["range_n_minutes"];
  }
}