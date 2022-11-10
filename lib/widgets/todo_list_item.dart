import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lista_tarefa/models/todoModel.dart';
 
class TodoListItem extends StatelessWidget {
  const TodoListItem({Key? key ,  required this.todoItem, required this.onDelete}) : super(key: key);

  final TodoModel todoItem;
  final Function(TodoModel) onDelete;
 

  @override
  Widget build(BuildContext context) {
    return  Slidable(
      actionPane:  const SlidableDrawerActionPane() ,
      // ignore: prefer_const_literals_to_create_immutables
      secondaryActions: [
        IconSlideAction(
          color: Colors.red,
          icon: Icons.delete,
          caption: 'Deletar',
          onTap: () { onDelete(todoItem);},
        )
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2 ),
        child: Container(
          decoration: BoxDecoration(  
               borderRadius:  BorderRadius.circular(10),
            color: Colors.grey[350],
          ),
         
          padding: const EdgeInsets.all(16),
          child: Column( 
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [ 
            Text( 
              DateFormat('dd/MM/yyyy - HH:mm').format(todoItem.date),
               style: TextStyle( 
                fontSize: 10, 
                )
            ),
       
            Text(
              todoItem.title,
              style:  TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            
              ),
          ]),
        ),
      ),
    );
  }
}
