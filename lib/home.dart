import 'package:flutter/material.dart';
import 'package:todolist_app/color.dart';
import 'package:todolist_app/text_item.dart';
import 'package:todolist_app/todolist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final todosList = ToDo.todolist();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

//darkmode button function
  ThemeData _currentTheme = ThemeData.dark(useMaterial3: true);

// Load ThemeData
  Future<ThemeData> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final brightnessIndex = prefs.getInt('themeBrightness');
    // Retrieve other saved theme attributes here
    // Example: Retrieve primaryColor, accentColor, etc.

    // Assuming default theme is dark mode
    final brightness = brightnessIndex != null
        ? Brightness.values[brightnessIndex]
        : Brightness.dark;

    // Return ThemeData based on retrieved attributes or defaults
    return ThemeData(
      brightness: brightness,
      // Set other retrieved attributes or default values here
      // Example: Set primaryColor, accentColor, etc.
    );
  }

  void thememode() {
    setState(
      () {
        if (_currentTheme == ThemeData.dark(useMaterial3: true)) {
          _currentTheme = ThemeData.light(useMaterial3: true);
        } else {
          _currentTheme = ThemeData.dark(useMaterial3: true);
        }
        _saveThemeMode(_currentTheme);
      },
    );
  }

//always shows the list
  @override
  void initState() {
    //loads theme
    _loadThemeMode().then((savedTheme) {
      setState(() {
        _currentTheme = savedTheme;
      });
    });

    //todo list is visble in instead of seach
    _foundToDo = todosList;

    //calls the saved data on localstorage
    _getSavedTodos();
    super.initState();
  }

//save themData
  Future<void> _saveThemeMode(ThemeData theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeBrightness', theme.brightness.index);
  }

//store todos in local storage
  Future<void> _getSavedTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedTodos = prefs.getString('todos');
    if (encodedTodos != null) {
      setState(() {
        todosList.clear();
        todosList.addAll(ToDo.decodeTodos(encodedTodos));
        _foundToDo = todosList;
      });
    }
  }

  //search button function
  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  //check uncheck function
  void _handleToDoChange(ToDo toDo) {
    setState(() {
      toDo.isDone = !toDo.isDone;
      _saveToSharedPreferences(todosList);
    });
  }

  //delete list function
  void _onDeleteItem(String? id) {
    if (id != null) {
      setState(() {
        todosList.removeWhere((item) => item.id == id);
        _saveToSharedPreferences(todosList);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Tried to delete an item with null ID.'),
        ),
      );
      // Handle the case when itemId is null
    }
  }

  //add item
  void _addtoddoItem(String toDo) {
    if (toDo.trim().isNotEmpty) {
      setState(() {
        todosList.add(
          ToDo(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            todoText: toDo.trim(),
          ),
        );
        _todoController.clear();
      });
      _saveToSharedPreferences(todosList);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _currentTheme == ThemeData.dark() ? dBlue : lBlue,
          content: Text(
            'Please enter a non-empty ToDo item',
            style: TextStyle(
                color: _currentTheme == ThemeData.dark() ? lBlue : dBlue),
          ),
        ),
      );
    }
  }

  Future<void> _saveToSharedPreferences(List<ToDo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedTodos = ToDo.encodeTodos(todos);
    await prefs.setString('todos', encodedTodos);
  }

//Dialog box function
  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title
          title: const Text(
            'Add Todo',
            style: TextStyle(
              color: dBlue,
            ),
          ),

          //hinttext label
          content: TextField(
            autofocus: true,
            controller: _todoController,
            decoration: const InputDecoration(
              hintText: 'Enter your todo here',
              border: InputBorder.none,
            ),
          ),

          actions: <Widget>[
            //close button
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: dBlue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            //addbutton
            ElevatedButton(
              child: const Text(
                'Add',
                style: TextStyle(color: dBlue),
              ),
              onPressed: () {
                _addtoddoItem(_todoController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _currentTheme,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: _currentTheme == ThemeData.dark() ? lBlue : dBlue,

        //appBar
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              // Open the drawer here
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(
              Icons.menu, // Replace with your preferred icon
              size: 30,
              color: _currentTheme == ThemeData.dark()
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          backgroundColor: _currentTheme == ThemeData.dark() ? lBlue : dBlue,
          title: Text(
            'Todo app',
            style: TextStyle(
                color: _currentTheme == ThemeData.dark()
                    ? Colors.black
                    : Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  //dark mode function
                  thememode();
                },
                icon: Icon(
                  Icons.dark_mode_outlined,
                  color: _currentTheme == ThemeData.dark()
                      ? Colors.black
                      : Colors.white,
                  size: 30,
                ))
          ],
        ),

        //3 dots
        drawer: Drawer(
          backgroundColor: _currentTheme == ThemeData.dark() ? lBlue : dBlue,
          child: Column(
            children: [
              DrawerHeader(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite,
                    color: _currentTheme == ThemeData.dark() ? dBlue : lBlue,
                    size: 70,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: Text(
                  'Made with love',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: _currentTheme == ThemeData.dark()
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        //main body
        // ignore: avoid_unnecessary_containers
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              //search box
              SearchBox(
                onFilter: _runFilter,
                currentTheme: _currentTheme,
              ),
              Expanded(
                child: ListView(
                  children: [
                    //All ToDos text
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(
                        'All ToDos',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: _currentTheme == ThemeData.dark()
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),

                    //todo list
                    for (ToDo todo in _foundToDo.reversed)
                      TodoItem(
                        todo: todo,
                        toDoChange: _handleToDoChange,
                        onDeleteItem: _onDeleteItem,
                        currentTheme: _currentTheme,
                      ),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  backgroundColor:
                      _currentTheme == ThemeData.dark() ? dBlue : lBlue,
                  onPressed: () {
                    //Dialog box opens up
                    _showAddTodoDialog(context);
                  },
                  shape: const CircleBorder(),
                  child: Icon(
                    Icons.add,
                    color: _currentTheme == ThemeData.dark()
                        ? tbWhiteColor
                        : tbBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//search box function
class SearchBox extends StatelessWidget {
  final Function(String) onFilter;
  final ThemeData currentTheme;

  const SearchBox({
    Key? key,
    required this.onFilter,
    required this.currentTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: tbWhiteColor,
      ),
      child: TextField(
        //onChanged = real time word catching
        onChanged: onFilter,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: dBlue,
          ),
          prefixIconConstraints: BoxConstraints(minHeight: 20, maxWidth: 30),
          hintText: ' Search',
          hintStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
