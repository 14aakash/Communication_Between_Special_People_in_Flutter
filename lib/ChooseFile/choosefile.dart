// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, void_checks, non_constant_identifier_names
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cbsp_gui/Components/main_drawer.dart';
import 'package:cbsp_gui/SignToText/CameraPage.dart';
import 'package:cbsp_gui/SignToText/signtotext.dart';
import 'package:cbsp_gui/TextToSign/string_extension.dart';
import 'package:cbsp_gui/TextToSign/texttosign.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ReceiveMessage extends StatefulWidget {
  const ReceiveMessage({Key? key}) : super(key: key);

  @override
  _ReceiveMessageState createState() => _ReceiveMessageState();
}

class _ReceiveMessageState extends State<ReceiveMessage> {
  bool value = false;
  bool playSlide = false;
  TextEditingController text3 = TextEditingController();
  final urlImages2 = [];
  @override
  void initState() {
    pickFile();
    // TODO: implement initState
    super.initState();
  }

  void pickFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["txt", ".text"]);
    final files = result?.files.map((file) => file.path).toList();
    if (files == null) {
      setState(() {
        if (selectedIndex == 1) {
          selectedIndex = 2;
        } else {
          selectedIndex = 1;
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignToText()),
        );
      });
      return;
    } else {
      var fpath = await result!.files[0].path;
      var ReceivedFile = File(fpath!);
      var content = await ReceivedFile.readAsString();
      // print("FILE DATA IS : " + content);
      // decoding from base64
      // String decoded = stringToBase64.decode(content);
      // print("Decoded from Base64 is : " + decoded);
      text3.text = content;
      updateSlides();
      var appDir = (await getTemporaryDirectory()).path;
      new Directory(appDir).delete(recursive: true);
    }
  }

  void updateSlides() {
    bool match_flag = false;
    bool isSen = false;
    String Text = text3.text;
    if (urlImages2.length >= 1 && Text.isNotEmpty)
      sliderController.animateToPage(0);
    urlImages2.clear();
    var sentence = '';
    for (int i = 0; i < Text.length; i++) {
      sentence += Text[i].capitalize();
    }
    //sentence matching
    for (String s in sen) {
      if (s == sentence) {
        isSen = true;
        var imgpath = "classes/" + s + ".gif";
        urlImages2.add(imgpath);
      }
    }
    if (isSen == false) {
      List<String> list_of_words = sentence.split(' ');
      //words matching
      for (int j = 0; j < list_of_words.length; j++) {
        var word = list_of_words[j];
        if (j != 0) {
          urlImages2.add("classes/SPACE.jpg");
        }
        match_flag = false;
        for (int i = 0; i < words.length; i++) {
          if (word == words[i]) {
            var imgpath = "classes/" + word + ".jpg";
            urlImages2.add(imgpath);
            match_flag = true;
          }
        }
        if (match_flag == false) {
          // alphabets matching
          for (int i = 0; i < word.length; i++) {
            var letter = word[i].capitalize();
            var imgpath = "classes/" + letter + ".jpg";

            File file = File(imgpath);
            String fileName = file.path.split('/').last;
            String fName = fileName.split('.').first;
            if (fName == ' ') {
              urlImages2.add("classes/SPACE.jpg");
            } else if (fName.contains(RegExp(r'[A-Z]'))) {
              urlImages2.add(imgpath);
            } else {
              print("Do Nothing!");
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: color,
        title: Text('Received Message'),
        // actions: <Widget>[
        //   Row(
        //     children: [
        //       Padding(padding: EdgeInsets.all(10)),

        //     ],
        //   ),
        // ],
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/w2.jpg'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: CheckboxListTile(
                      value: value,
                      onChanged: (value) => setState(() {
                        this.value = value!;
                        playSlide = !playSlide;
                      }),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Image.asset(
                        'assets/asl.png',
                        height: 50,
                        width: 50,
                      ),
                      checkColor: Colors.white,
                      activeColor: color,
                    ),
                  ),
                ),
              ],
            ),
            Flex(
              direction: Axis.vertical,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: TextFormField(
                    maxLines: 2,
                    readOnly: true,
                    controller: text3,
                    //cursorColor: Colors.white,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      hintStyle: TextStyle(
                        //fontSize: 20,
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.only(left: 14, right: 14, top: 25),
                      hintText: 'Receiving a Message',
                      hintMaxLines: 5,
                      // suffixIcon: IconButton(
                      //   onPressed: null,
                      //   icon: Icon(
                      //     Icons.share,
                      //     color: Colors.black,
                      //   ),
                      // ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                playSlide
                    ? CarouselSlider.builder(
                        options: CarouselOptions(
                          height: 200,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 2),
                          enableInfiniteScroll: false,
                        ),
                        itemCount: urlImages2.length,
                        itemBuilder: (Context, index, realIndex) {
                          final urlImage2 = urlImages2[index];
                          return buildImage(urlImage2, index);
                        },
                      )
                    : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
