# Task Managing app

A simple flutter application made with flutter.

## Overview

This is app is a simple todo list that allows you to add, edit, remove, check and set reminders for tasks.

## Usage

This section is usage guide on how the app should be used.

### First Look

![alt text](https://github.com/AhmeddNofal/todoapp/blob/main/screenshots/scr1.png?raw=true)

Once you open the app you should see an empty page with only a text field and a button.

### Adding a Task

In order to add a task simply write the task in the text field and press the add button or enter on your keyboard
and the task should be added.

![alt text](https://github.com/AhmeddNofal/todoapp/blob/main/screenshots/scr2.png?raw=true)
![alt text](https://github.com/AhmeddNofal/todoapp/blob/main/screenshots/scr3.png?raw=true)

once you finish your task you can check it off by pressing on the checkbox.

![alt text](https://github.com/AhmeddNofal/todoapp/blob/main/screenshots/scr4.png?raw=true)


### Editing a Task

To edit a task press on the options button on the right of the task then press on "edit" which
will open a dialog box from where you can rewrite your task.

![alt text](https://github.com/AhmeddNofal/todoapp/blob/main/screenshots/scr5.png?raw=true)
![alt text](https://github.com/AhmeddNofal/todoapp/blob/main/screenshots/scr6.png?raw=true)

### Removing a Task

To delete a task simply slide the task from right ot left to reveal the delete button which deletes 
the task once pressed.

![alt text](https://github.com/AhmeddNofal/todoapp/blob/main/screenshots/scr8.png?raw=true)

### Setting Reminders

To set a reminder press the options button on the right of the task then press on "edit" which
will open a time picker for you to choose the time you want to be reminded at.

![alt text](https://github.com/AhmeddNofal/todoapp/blob/main/screenshots/scr5.png?raw=true)
![alt text](https://github.com/AhmeddNofal/todoapp/blob/main/screenshots/scr7.png?raw=true)

## Documentaion

This section covers how the app is built.

### Architecture

The project consists of three dart files found in the lib folder which are
 - pages/homepage.dart
 - widgets/task.dart
 - main.dart

#### main.dart

This is where the main function that runs our app and initializes dependencies resides.

#### hompage.dart

As the name implies this is the homepage of the application (only page for the time being)
it includes the state "tasks" where we keep track of the tasks as a 2d array and the fuctions for the 
CRUD operations such as addTask().

#### task.dart

This file contains the Task widget which is rendered by the Homepage with the tasks in its state by looping through the
tasks list and passing and returning a Task widget with the data of each task.

### Storage

The app uses shared preferences  to store the data locally.

### Dependencies

The packages used in this project are

#### Awesome Notifications

Used to send notifications.

#### Shared preferences plugin

Used to store data.

#### fluttertoast

Used to send toasts.

#### flutter_slidable 

Used to create the delete slidable button.
