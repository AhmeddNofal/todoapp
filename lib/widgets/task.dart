import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Task extends StatefulWidget {
  const Task(
      {super.key,
      required this.taskText,
      required this.completed,
      this.onToggle,
      this.deleteFunction,
      required this.editPopupEvent,
      required this.reminderPopupEvent});

  final String taskText;
  final bool completed;
  final void Function(bool?)? onToggle;
  final Function(BuildContext)? deleteFunction;
  final void Function() editPopupEvent;
  final void Function() reminderPopupEvent;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  List<String> list = <String>['Edit', 'Set Reminder'];

  void openDialog(String choice) {
    if (choice == 'Edit') {
      widget.editPopupEvent();
    } else if (choice == 'Set Reminder') {
      widget.reminderPopupEvent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: widget.deleteFunction,
                backgroundColor: Colors.red.shade700,
                icon: Icons.delete,
                borderRadius: BorderRadius.circular(15),
              ),
            ],
          ),
          child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Color.fromRGBO(218, 34, 255, 1),
                      Color.fromRGBO(151, 51, 238, 1)
                    ]),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: widget.completed,
                    onChanged: widget.onToggle,
                    checkColor: Colors.grey[800],
                    activeColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      widget.taskText,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          decoration: widget.completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: Colors.white,
                          decorationThickness: 2.5),
                    ),
                  ),
                  // IconButton(
                  //   onPressed: widget.popupEvent,
                  //   icon: const Icon(Icons.edit),
                  //   color: Colors.white,
                  // )
                  PopupMenuButton(
                      iconColor: Colors.white,
                      onSelected: openDialog,
                      itemBuilder: (BuildContext context) {
                        return list.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      })
                  // DropdownButton(
                  //     items: list.map<DropdownMenuItem<String>>((String value) {
                  //       return DropdownMenuItem<String>(
                  //         value: value,
                  //         child: Text(value),
                  //       );
                  //     }).toList(),
                  //     onChanged: (value) {})
                ],
              )),
        ),
      ),
    );
  }
}
