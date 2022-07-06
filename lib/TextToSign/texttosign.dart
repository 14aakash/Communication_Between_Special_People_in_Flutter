// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_print, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import "string_extension.dart";
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cbsp_gui/Components/main_drawer.dart';
import 'package:cbsp_gui/SignToText/CameraPage.dart';
import 'package:cbsp_gui/SignToText/signtotext.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:share_plus/share_plus.dart';

// Codec<String, String> stringToBase64 = utf8.fuse(base64);
final urlImages = [];
List<String> words = [
  'ABOUT',
  'AGREE',
  'BUT',
  'HAVE',
  'HOW',
  'MAKE',
  'NAME',
  'VISIT',
  'WHAT',
  'WHEN'
];
List<String> sen = [
  'HELLO',
  'HOW ARE YOU',
  'I AM FINE',
  'THANK YOU',
  'WHERE ARE YOU FROM',
];
bool isSentence = false;
int activeIndex = 0;
final sliderController = CarouselController();

class TextToSign extends StatefulWidget {
  const TextToSign({Key? key}) : super(key: key);

  @override
  _TextToSignState createState() => _TextToSignState();
}

TextEditingController text2 = TextEditingController();

class _TextToSignState extends State<TextToSign> {
  bool isPlay = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: color,
        title: Text('Text To Sign'),
        actions: <Widget>[
          Row(
            children: [
              Padding(padding: EdgeInsets.all(10)),
              GestureDetector(
                onTap: () {
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
                },
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/black_converter2.png',
                      height: 40,
                      //width: 90,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/sl.png'),
        //     fit: BoxFit.contain,
        //   ),
        // ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 90,
                //color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: TextFormField(
                    autofocus: true,
                    controller: text2,
                    maxLines: 2,
                    //cursorColor: Colors.white,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      // hintStyle: TextStyle(
                      //   fontSize: 20,
                      //   //color: Colors.black,
                      // ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.only(left: 14, right: 14, top: 25),

                      hintText: 'Type Here',
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (text2.text == '') {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    // title: Text("Sorry!"),
                                    content: Text(
                                        "Sorry! Please type something to play slides."),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                          child: Text("OK"))
                                    ],
                                  ),
                                  barrierDismissible: false,
                                );
                              } else {
                                setState(() {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  isPlay = !isPlay;
                                  isSentence = false;
                                  bool match_flag = false;
                                  String Text = text2.text;
                                  if (urlImages.length >= 1 && Text.isNotEmpty)
                                    sliderController.animateToPage(0);
                                  urlImages.clear();
                                  var sentence = '';
                                  for (int i = 0; i < Text.length; i++) {
                                    sentence += Text[i].capitalize();
                                  }
                                  //sentence matching
                                  for (String s in sen) {
                                    if (s == sentence) {
                                      isSentence = true;
                                      var imgpath = "classes/" + s + ".gif";
                                      urlImages.add(imgpath);
                                    }
                                  }
                                  if (isSentence == false) {
                                    //words matching
                                    List<String> list_of_words =
                                        sentence.split(' ');

                                    for (int j = 0;
                                        j < list_of_words.length;
                                        j++) {
                                      var word = list_of_words[j];
                                      if (j != 0) {
                                        urlImages.add("classes/SPACE.jpg");
                                      }
                                      match_flag = false;
                                      for (int i = 0; i < words.length; i++) {
                                        if (word == words[i]) {
                                          var imgpath =
                                              "classes/" + word + ".jpg";
                                          urlImages.add(imgpath);
                                          match_flag = true;
                                        }
                                      }
                                      if (match_flag == false) {
                                        // alphabets matching
                                        for (int i = 0; i < word.length; i++) {
                                          var letter = word[i].capitalize();
                                          var imgpath =
                                              "classes/" + letter + ".jpg";

                                          File file = File(imgpath);
                                          String fileName =
                                              file.path.split('/').last;
                                          String fName =
                                              fileName.split('.').first;
                                          if (fName == ' ') {
                                            urlImages.add("classes/SPACE.jpg");
                                          } else if (fName
                                              .contains(RegExp(r'[A-Z]'))) {
                                            urlImages.add(imgpath);
                                          } else {
                                            print("Do Nothing!");
                                          }
                                        }
                                      }
                                    }
                                  }
                                });
                              }
                            },
                            icon: Icon(
                              Icons.play_circle_outline_sharp,
                              size: 32,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (text2.text != '') {
                                final filename = join(
                                    (await getExternalStorageDirectory())!.path,
                                    'Message.txt');
                                //Encoding in base64
                                // String encoded =
                                //     stringToBase64.encode(text2.text);
                                // print("Encoded in Base64 is : " + encoded);
                                //decoding from base64
                                // String decoded = stringToBase64.decode(encoded);
                                // print("Decoded from Base64 is : " + decoded);
                                var file = File(filename);
                                await file.writeAsString(text2.text);
                                // var content = await file.readAsString();
                                // print("FILE DATA IS : " + content);
                                await Share.shareFiles([filename]);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    // title: Text("Sorry!"),
                                    content: Text(
                                        "Sorry! Please type something to share."),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                          child: Text("OK"))
                                    ],
                                  ),
                                  barrierDismissible: false,
                                );
                              }
                            },
                            icon: Icon(
                              Icons.share,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Expanded(
            //   flex: 0,
            //   child: SizedBox(
            //     height: 20,
            //   ),
            // ),
            urlImages.length > 0
                ? Expanded(
                    flex: 2,
                    child: CarouselSlider.builder(
                      carouselController: sliderController,
                      options: CarouselOptions(
                        height: 350,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 2),
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        pauseAutoPlayOnManualNavigate: false,
                        onPageChanged: (index, reason) =>
                            setState(() => activeIndex = index),
                      ),
                      itemCount: urlImages.length,
                      itemBuilder: (Context, index, realIndex) {
                        final urlImage = urlImages[index];
                        return buildImage(urlImage, index);
                      },
                    ),
                  )
                : Expanded(
                    flex: 2,
                    child: Container(
                        // decoration: BoxDecoration(
                        //   image: DecorationImage(
                        //     image: AssetImage('assets/sl1.png'),
                        //     fit: BoxFit.contain,
                        //   ),
                        // ),
                        ),
                  ),
            Expanded(flex: 2, child: SizedBox()),
            // Expanded(
            //     flex: 1,
            //     child: urlImages.length > 1 ? buildIndicator() : SizedBox()),
          ],
        ),
      ),
    );
  }
}

Widget buildImage(String urlImage, int index) => Container(
      margin: EdgeInsets.symmetric(horizontal: 0),
      color: Colors.grey,
      child: Image.asset(urlImage, fit: BoxFit.cover),
    );

// Widget buildIndicator() => AnimatedSmoothIndicator(
//     onDotClicked: animateToSlide,
//     activeIndex: activeIndex,
//     count: urlImages.length,
//     effect: SlideEffect(activeDotColor: color));

void animateToSlide(index) => sliderController.animateToPage(index);
