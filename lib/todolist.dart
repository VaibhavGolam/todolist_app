import 'dart:convert';

class ToDo {
  String? id;
  String? todoText;
  bool isDone;

//push github
  // Method to convert ToDo object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoText': todoText,
      'isDone': isDone,
    };
  }

  // Factory method to create a ToDo object from a map
  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      todoText: map['todoText'],
      isDone: map['isDone'] ?? false,
    );
  }

  static String encodeTodos(List<ToDo> todos) {
    final List<Map<String, dynamic>> encodedList =
        todos.map((todo) => todo.toMap()).toList();
    return json.encode(encodedList);
  }

  static List<ToDo> decodeTodos(String encodedTodos) {
    final List<dynamic> decodedList = json.decode(encodedTodos);
    return decodedList.map((item) => ToDo.fromMap(item)).toList();
  }

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todolist() {
    return [
      ToDo(id: '1', todoText: 'Delete me', isDone: true),
      ToDo(id: '2', todoText: 'Click me'),
      ToDo(id: '3', todoText: 'Make you first ToDo')
    ];
  }
}
