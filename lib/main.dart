import 'dart:isolate';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
}

@pragma('vm:entry-point')
void backgroundTTS() async {
  FlutterTts flutterTts = FlutterTts();

  String textToSpeak = "Hello, this is a scheduled message!";
  await flutterTts.speak(textToSpeak);
}

Future<void> scheduleTTS() async {
  DateTime scheduleTime = DateTime.now().add(const Duration(seconds: 10)); // Schedule for 1 hour later
  await AndroidAlarmManager.oneShotAt(scheduleTime, 0, backgroundTTS, wakeup: true);
}

Future<void> permissionChecker() async {
  final status = await Permission.scheduleExactAlarm.request();
  if (status.isDenied) {
    await openAppSettings();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AndroidAlarmManager.initialize();
  runApp(const MyApp());
  //scheduleTTS();
  await permissionChecker();
  const int helloAlarmID = 0;
  await AndroidAlarmManager.periodic(const Duration(seconds: 10), helloAlarmID, backgroundTTS, wakeup: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Container(),
    );
  }
}
