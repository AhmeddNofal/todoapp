import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:todo/pages/homepage.dart';

void main() async {
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelGroupKey: 'reminders_channel_group',
        channelKey: 'reminders',
        channelName: 'reminders',
        channelDescription: 'Task Reminders')
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: 'reminders_channel_group',
        channelGroupName: 'Reminers Group')
  ]);
  bool isAllowedToSendNotification = await AwesomeNotifications().isNotificationAllowed();
  if(!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Todo App',
      home: MyHomePage(),
    );
  }
}
