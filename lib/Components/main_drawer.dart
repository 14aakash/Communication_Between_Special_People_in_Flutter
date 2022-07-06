// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:cbsp_gui/ChooseFile/choosefile.dart';
import 'package:cbsp_gui/SignToText/CameraPage.dart';
import 'package:cbsp_gui/SignToText/signtotext.dart';
import 'package:cbsp_gui/TextToSign/texttosign.dart';
import 'package:flutter/material.dart';

import '../Tutor.dart';
import '../student.dart';

var selectedIndex = 1;

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: color,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 30,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/mainlogo.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text("Communication Between Special People",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                ],
              ),
            ),
          ),
          // ListView.builder(
          //   itemCount: 10,
          //   itemBuilder: (BuildContext context, int index) {
          //     return ListTile(
          //       title: Text('Item $index'),
          //       selected: index == _selectedIndex,
          //       onTap: () {
          //         setState(() {
          //           _selectedIndex = index;
          //         });
          //       },
          //     );
          //   },
          // ),
          ListTile(
            selected: selectedIndex == 1 ? true : false,
            leading: Icon(Icons.hearing_disabled),
            title: Text("Sign to Text",
                style: TextStyle(
                  fontSize: 16,
                )),
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignToText()),
              );
            },
          ),
          ListTile(
            selected: selectedIndex == 2 ? true : false,
            leading: Icon(Icons.hearing),
            title: Text("Text to Sign",
                style: TextStyle(
                  fontSize: 16,
                )),
            onTap: () {
              setState(() {
                selectedIndex = 2;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TextToSign()),
              );
            },
          ),
          ListTile(
              selected: selectedIndex == 3 ? true : false,
              leading: Icon(Icons.folder_outlined),
              title: Text("Choose File",
                  style: TextStyle(
                    fontSize: 16,
                  )),
              onTap: () {
                setState(() {
                  selectedIndex = 3;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReceiveMessage(),
                  ),
                );
              }),
          ListTile(
            selected: selectedIndex == 4 ? true : false,
            leading: Icon(Icons.arrow_forward),
            title: Text("Tutor",
                style: TextStyle(
                  fontSize: 16,
                )),
            onTap: () {
              setState(() {
                selectedIndex = 4;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Tutor(),
                ),
              );
            },
          ),
          ListTile(
            selected: selectedIndex == 5 ? true : false,
            leading: Icon(Icons.arrow_forward),
            title: Text("Student",
                style: TextStyle(
                  fontSize: 16,
                )),
            onTap: () {
              setState(() {
                selectedIndex = 5;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Student(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
