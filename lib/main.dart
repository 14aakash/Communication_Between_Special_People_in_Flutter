//@dart=2.9
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SignToText/signtotext.dart';
import 'SignToText/CameraPage.dart';
import 'Components/globals.dart' as globals;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  cameras = await availableCameras();
  // final prefs = await SharedPreferences.getInstance();
  // globals.firstscreen = prefs.getBool('firstscreen') ?? false;
  runApp(const SignToText());
}
