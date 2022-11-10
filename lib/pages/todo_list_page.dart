import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lista_tarefa/models/ordemListModel.dart';
import 'package:lista_tarefa/models/todoModel.dart';
import 'package:lista_tarefa/repositories/todo_repositorie.dart';
import 'package:lista_tarefa/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController toDoController = TextEditingController();
  final TodoRepositorie todoRepositorie = TodoRepositorie();
  
  num numberTarefa = 0;

  List<TodoModel> toDoLists = [];
  List<OrdemModel> ordem = [];
  late TodoModel lastTododeleted;
  late int lastTododeletedPosition;
  String? errorText; 

  @override
  void initState(){
    super.initState();

    todoRepositorie.getTodoList().then((value) {
      setState(() {
        toDoLists = value;
      });
    });
  }
  
  void addToDo() {
    String text = toDoController.text;
    if(text.isEmpty){
      setState(() {
          errorText =' preencher o campo';
      });
    
    };
    return 

    setState(() {
      TodoModel newTodo = TodoModel(
        title: text,
        date: DateTime.now(),
      );

      toDoController.clear();
      toDoLists.add(newTodo);
      errorText = null;
      todoRepositorie.saveTodoList(toDoLists);
      OrdemModel newOrder = OrdemModel(number: toDoLists.length);
      numberTarefa = newOrder.number;
    });

    print('$toDoLists');
  }

  void onDelete(TodoModel todo) {
    setState(() {
      lastTododeleted = todo;
      lastTododeletedPosition = toDoLists.indexOf(todo);
      print('$lastTododeleted $lastTododeletedPosition');
      toDoLists.remove(todo);
        todoRepositorie.saveTodoList(toDoLists);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tarefa: ${todo.title} foi removida',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              toDoLists.insert(lastTododeletedPosition, lastTododeleted);
            });
          }),
      duration: const Duration(seconds: 4),
    ));
  }

  void showDeleteTodoConfirmation() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Remover '),
              content: Text('Você deseja remover tudo?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                          Navigator.of(context).pop();
                          removeAll();
                  },
                  child: Text('Deletar'),
                )
              ],
            ));
  }

  void removeAll() {
    setState(() {
      toDoLists.clear();
        todoRepositorie.saveTodoList(toDoLists);
      // toDoLists = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: toDoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Adicione uma tarefa',
                          labelText: 'Adicione uma tarefa',
                          errorText: errorText,
                          focusedBorder:  OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 2)
                          )
                          
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xff00d7f3),
                            padding: EdgeInsets.all(14),
                          ),
                          onPressed: addToDo,
                          child: Icon(
                            Icons.add,
                            size: 30,
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (TodoModel item in toDoLists)
                        TodoListItem(todoItem: item, onDelete: onDelete)
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('Você possui $numberTarefa tarefas'),
                    ),
                    ElevatedButton(
                      onPressed: showDeleteTodoConfirmation,
                      child: Text('Limpar tudo'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
