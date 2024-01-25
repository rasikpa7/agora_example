import 'package:agoraexample/screens/agora_screen.dart';
import 'package:agoraexample/screens/home_screen.dart';
import 'package:agoraexample/widgets/video_call_widget.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  void requestPermissions()async{
        await [Permission.microphone, Permission.camera].request();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermissions();
  }
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BaseVideoCallPage()
    );
  }
}

