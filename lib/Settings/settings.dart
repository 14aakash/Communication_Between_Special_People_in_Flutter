// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cbsp_gui/Components/main_drawer.dart';
import 'package:cbsp_gui/Settings/signs.dart';
import 'package:cbsp_gui/Settings/texts.dart';
import 'package:cbsp_gui/SignToText/CameraPage.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            drawer: MainDrawer(),
            appBar: AppBar(
              backgroundColor: color,
              title: Text('Settings'),
              bottom: TabBar(
                labelColor: Colors.white,
                tabs: <Widget>[
                  Tab(text: "SIGN"),
                  Tab(
                    text: "TEXT",
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Signs(),
                Texts(),
              ],
            )),
      ),
    );
  }
}
