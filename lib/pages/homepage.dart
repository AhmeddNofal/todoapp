import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
            _scrollController.position.minScrollExtent &&
        tasks.length > 4) {
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
                cursorColor: Colors.teal,
                autofocus: true,
                controller: _editController,
                onSubmitted: (value) => editTask(index),
                decoration: const InputDecoration(
                  hintText: 'Enter New Task',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal)
                  )
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => editTask(index),
                    child: const Text('SUBMIT',style: TextStyle(color: Colors.teal),))
              ],
            ));
  }

  void reminderPopup(int index) async {
    TimeOfDay scheduledTime = TimeOfDay.now();

    final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: scheduledTime,
        initialEntryMode: TimePickerEntryMode.dial,
         builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: const ColorScheme.light(
                      // change the border color
                      primary: Color.fromRGBO(38, 120, 113, 1),
                      // change the text color
                      onSurface: Color.fromRGBO(38, 120, 113, 1),
                    ),
                    // button colors 
                    buttonTheme: const ButtonThemeData(
                      colorScheme: ColorScheme.light(
                        primary: Color.fromRGBO(38, 120, 113, 1),
                      ),
                    ),
                    timePickerTheme: TimePickerTheme.of(context).copyWith(
                        dayPeriodColor: const Color.fromRGBO(50, 153, 144, 1),
                    )
                  ),
                  
                  child: child!,
                );
              }
        );
    if (time != null) {
      setState(() {
        scheduledTime = time;
      });
      //converting to DateTime format
      var tmp = DateTime.now();
      tmp = DateTime(tmp.year, tmp.month, tmp.day, scheduledTime.hour,
          scheduledTime.minute);
      if (tmp.isAfter(DateTime.now())) {
        var text = tasks[index][0];
        AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 1,
              channelKey: 'reminders',
              title: 'Task Reminder',
              body: '$text',
            ),
            schedule: NotificationCalendar.fromDate(date: tmp));
        Fluttertoast.showToast(msg: "Reminder has been set", fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Please set reminder in the future", fontSize: 16.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  Color.fromRGBO(19, 106, 138, 1),
                  Color.fromRGBO(38, 120, 113, 1)
                ]),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView(
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
                    reminderPopupEvent: () => reminderPopup(i),
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
        color: Colors.white,
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
                  fillColor: const Color.fromRGBO(38, 120, 113, 0.075),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(38, 120, 113, 1),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(38, 120, 113, 1),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            )),
            FloatingActionButton(
              onPressed: addTask,
              backgroundColor: const Color.fromRGBO(38, 120, 113, 1),
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
