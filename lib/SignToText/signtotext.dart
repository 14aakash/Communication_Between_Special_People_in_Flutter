// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cbsp_gui/Components/main_drawer.dart';
import 'package:cbsp_gui/TextToSign/texttosign.dart';
import 'package:flutter/material.dart';
import '../Tutor.dart';
import '../student.dart';
import 'CameraPage.dart';
import '../Components/globals.dart' as globals;

class SignToText extends StatefulWidget {
  const SignToText({Key? key}) : super(key: key);

  @override
  _SignToTextState createState() => _SignToTextState();
}

class _SignToTextState extends State<SignToText> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "CBSP",
      theme: ThemeData.light().copyWith(
        primaryColor: color,
        unselectedWidgetColor: Colors.black,
      ),
      // home: globals.firstscreen ? CameraPage() : OnBoardingScreen(),
      home: CameraPage(),
    );
  }
}
