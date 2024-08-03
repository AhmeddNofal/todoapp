import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/widgets/task.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _addController = TextEditingController();
  final _editController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  List tasks = [];

  @override
  void initState() {
    super.initState();

    initializeData();
  }

  void initializeData() async {
    var prefs = await SharedPreferences.getInstance();
    // await prefs.remove('data');
    var data = prefs.getString('data');

    setState(() {
      if (data != null) {
        tasks = jsonDecode(data);
      }
    });
  }

  Future updateStorage() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(tasks));
  }

  void toggle(int index) async {
    setState(() {
      tasks[index][1] = !tasks[index][1];
    });
    await updateStorage();
  }

  void updateOrder(int oldIndex, int newIndex) async {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex--;
      }
      var task = tasks.removeAt(oldIndex);
      tasks.insert(newIndex, task);
    });
    await updateStorage();
  }

  void addTask() async {
    setState(() {
      if (_addController.text != '') {
        tasks.add([_addController.text, false]);
        //clear text field
        _addController.clear();
      }
    });
    await updateStorage();
    if (_scrollController.offset ==
        _scrollController.position.minScrollExtent && tasks.length > 4) {
      _scrollController
          .jumpTo(_scrollController.position.maxScrollExtent + 150);
    } else {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void deleteTask(int index) async {
    setState(() {
      tasks.removeAt(index);
    });
    await updateStorage();
  }

  void editTask(int index) async {
    setState(() {
      if (_editController.text != '') {
        tasks[index][0] = _editController.text;
      }
    });
    //clear text field
    _editController.clear();
    //exit dialog
    Navigator.of(context).pop();
    await updateStorage();
  }

  void editPopup(int index) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Edit Task'),
              content: TextField(
                autofocus: true,
                controller: _editController,
                onSubmitted: (value) => editTask(index),
                decoration: const InputDecoration(
                  hintText: 'Enter New Task',
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => editTask(index),
                    child: const Text('SUBMIT'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text("My List"),
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color.fromRGBO(218, 34, 255, 1),
                  Color.fromRGBO(151, 51, 238, 1)
                ]),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView(
              // shrinkWrap: true,
              scrollController: _scrollController,
              proxyDecorator: (child, index, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    return Material(
                      elevation: 0,
                      color: Colors.transparent,
                      child: child,
                    );
                  },
                  child: child,
                );
              },
              onReorder: (oldIndex, newIndex) =>
                  updateOrder(oldIndex, newIndex),
              children: [
                for (int i = 0; i < tasks.length; i++)
                  Task(
                    taskText: tasks[i][0],
                    completed: tasks[i][1],
                    key: ValueKey(i),
                    onToggle: (value) => toggle(i),
                    deleteFunction: (contex) => deleteTask(i),
                    editPopupEvent: () => editPopup(i),
                    // updateFunc: (context) => editTask(i),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: 90,
          )
        ],
      ),
      floatingActionButton: Container(
        color: Colors.deepPurple[50],
        child: Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _addController,
                onSubmitted: (value) => addTask(),
                decoration: InputDecoration(
                  hintText: 'Add a new todo items',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: const Color.fromARGB(27, 218, 34, 255),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(168, 19, 198, 0.329),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(168, 19, 198, 0.329),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            )),
            FloatingActionButton(
              onPressed: addTask,
              backgroundColor: const Color.fromRGBO(218, 34, 255, 0.753),
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
