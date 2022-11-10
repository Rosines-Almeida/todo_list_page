import 'dart:convert';

import 'package:lista_tarefa/models/todoModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

const todoListKey = 'todo-list';

class TodoRepositorie {

Future<List<TodoModel>> getTodoList() async{
  sharedPreferences = await SharedPreferences.getInstance();
  final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
  final List jsonDecoded =  json.decode(jsonString) as List;
  return jsonDecoded.map((e) => TodoModel.fromJson(e)).toList();

}

  // TodoRepositorie() {
  //   SharedPreferences.getInstance().then((value) {
  //     sharedPreferences = value;
  //     print(sharedPreferences.getString('todo-list'));
  //   }); 
  // }

  late SharedPreferences sharedPreferences;

   void saveTodoList (List<TodoModel> todos){
    final String jsonString =json.encode(todos);  
    sharedPreferences.setString(todoListKey, jsonString);
    print('repo $jsonString');
  

}
  
  }

 

