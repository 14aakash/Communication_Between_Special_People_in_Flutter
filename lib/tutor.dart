// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:io';

import 'package:cbsp_gui/Components/globals.dart';
import 'package:cbsp_gui/SignToText/CameraPage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'Components/main_drawer.dart';

TextEditingController t = TextEditingController();
var content = '';
var filename;

class Tutor extends StatefulWidget {
  const Tutor({Key? key}) : super(key: key);

  @override
  State<Tutor> createState() => _TutorState();
}

class _TutorState extends State<Tutor> {
  @override
  void initState() {
    Refresh();
    super.initState();
  }

  Refresh() async {
    filename =
        join((await getExternalStorageDirectory())!.path, 'Dictionary.txt');
    var ReceivedFile = File(filename);
    var data = await ReceivedFile.readAsString();
    setState(() {
      content = data;
    });
  }

  Write() async {
    var file = File(filename);
    var word;
    if (content == '') {
      content = t.text;
      word = t.text;
    } else {
      word = content + "\n" + t.text;
    }
    await file.writeAsString(word);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: color,
        title: Text('Tutor'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  height: 60,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: "Type here to Add Word",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      controller: t,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(7),
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      child: Text("Add"),
                      onPressed: () {
                        if (t.text.isEmpty) {
                          print("empty"); //Alert Dialog
                        } else {
                          setState(() {
                            Write();
                            Refresh();
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 200,
            color: color,
            child: Text("Dictionary",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                )),
          ),
          // Expanded(
          //   child: Container(
          //     child: ListView.builder(
          //         itemCount: dic.length,
          //         itemBuilder: (BuildContext context, int i) {
          //           return ListTile(
          //             title: Text(
          //               dic[i],
          //               style: TextStyle(
          //                 fontSize: 16,
          //               ),
          //             ),
          //           );
          //         }),
          //   ),
          // ),
          Expanded(
            child: Container(
              child: ListTile(
                title: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// showlist() {
//   for (int i = 0; i < dic.length; i++) {
//     print(dic[i]);
//   }
// }

