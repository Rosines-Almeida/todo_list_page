class TodoModel {

  TodoModel({required this.title , required this.date});

  TodoModel.fromJson(Map<String, dynamic> json)
    :title = json['title'],
     date = DateTime.parse(json['datetime']);

  String  title;
  DateTime date;

 Map<String, dynamic> toJson(){
  return {
    'title': title,
    // armazenamento de dadta e horarios-notion
    'datetime': date.toIso8601String(), 
  };
} 
}