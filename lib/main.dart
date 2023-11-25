import 'package:flutter/material.dart';
import 'package:todolist_app/home.dart';

void main() {
  runApp(const TodoListHomePage());
}

class TodoListHomePage extends StatelessWidget {
  const TodoListHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      home: Home(),
    );
  }
}
