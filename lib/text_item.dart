import 'package:flutter/material.dart';
import 'package:todolist_app/color.dart';
import 'package:todolist_app/todolist.dart';

class TodoItem extends StatelessWidget {
  final ToDo todo;
  final Function(ToDo) toDoChange;
  final void Function(String) onDeleteItem;
  final ThemeData currentTheme;
  const TodoItem({
    Key? key,
    required this.todo,
    required this.toDoChange,
    required this.onDeleteItem,
    required this.currentTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = currentTheme.brightness == Brightness.light;
    // ignore: avoid_unnecessary_containers
    return Container(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        onTap: () {
          toDoChange(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        //checkbox
        tileColor: tbWhiteColor,
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          size: 30,
          color: dBlue,
        ),

        //String
        title: Stack(
          children: [
            Text(
              todo.todoText!,
              style: TextStyle(
                fontSize: 16,
                color: todo.isDone
                    ? dBlue
                    : Colors.black, // Change color based on isDone
                decoration: todo.isDone ? TextDecoration.lineThrough : null,
                decorationColor: isLightTheme ? dBlue : dBlue,
              ),
            ),
          ],
        ),

        //delete
        trailing: IconButton(
          onPressed: () {
            final todoId = todo.id;

            if (todoId != null) {
              onDeleteItem(todoId); // Safe to pass todoId as String here
            } else {
              // Handle the case when todo.id is null
            }
          },
          icon: const Icon(
            Icons.delete,
            color: dBlue,
            size: 30,
          ),
        ),
      ),
    );
  }
}
