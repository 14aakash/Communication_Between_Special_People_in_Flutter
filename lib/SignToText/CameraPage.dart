// ignore_for_file: file_names, import_of_legacy_library_into_null_safe, prefer_const_constructors, prefer_const_literals_to_create_immutables, implementation_imports
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_compress/video_compress.dart';

import 'dart:developer';
import 'package:cbsp_gui/Components/main_drawer.dart';
import 'package:cbsp_gui/TextToSign/texttosign.dart';
import 'package:http/http.dart' as ht;
import 'package:dio/dio.dart';
import 'package:dio/src/multipart_file.dart' as mpf;
import 'package:http_parser/http_parser.dart';
//import 'ViewVideo.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

String ip = 'http://192.168.43.17:5000/';
late List<CameraDescription> cameras;
bool isFrontCam = false;
bool isRecording = false;
bool isLoading = false;
bool isTapped = false;
int camerapos = 0;
List<bool> type = [true, false];
const color = const Color(0xff1a1918);
String videopath = '';
String check = 'Go Back';
var dio = Dio();
var response;
String vname = '';
late MediaInfo? compressed_video;

TextEditingController text = TextEditingController();

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

late CameraController _cameraController;
late Future<void> cameraValue;

class _CameraPageState extends State<CameraPage> {
  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
        cameras[camerapos], ResolutionPreset.low,
        enableAudio: false);
    cameraValue = _cameraController.initialize();
    type = [true, false];
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: color,
        // title: Text(
        //   'Sign To Text',
        //   maxLines: 2,
        //   style: TextStyle(fontSize: 12),
        // ),
        //Static/Dynamic Start
        title: Container(
          height: 40,
          child: ToggleButtons(
            borderColor: Colors.white30,
            selectedColor: color,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            fillColor: Colors.white,
            textStyle: TextStyle(
              fontSize: 14,
            ),
            color: Colors.white30,
            children: [Text("  Static  "), Text("  Dynamic  ")],
            isSelected: type,
            onPressed: (int index) {
              setState(() {
                index == 0 ? type = [true, false] : type = [false, true];
                // type[index] = !type[index];
              });
            },
          ),
        ),
        //END,

        actions: <Widget>[
          Row(
            children: [
              //Padding(padding: EdgeInsets.all(10)),
              IconButton(
                  icon: Icon(Icons.flip_camera_android_outlined,
                      color: Colors.white, size: 28),
                  onPressed: () {
                    setState(() {
                      isFrontCam = !isFrontCam;
                    });
                    camerapos = isFrontCam ? 1 : 0;
                    _cameraController = CameraController(
                        cameras[camerapos], ResolutionPreset.low,
                        enableAudio: false);
                    cameraValue = _cameraController.initialize();
                  }),

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
                      MaterialPageRoute(builder: (context) => TextToSign()),
                    );
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/black_converter.png',
                      height: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        onDoubleTap: () async {
          if (!isRecording) {
            String testurl = ip + "/testing";
            var testRes = await ht.get(Uri.parse(testurl)).timeout(
              const Duration(seconds: 1),
              onTimeout: () {
                return ht.Response('Error', 408);
              },
            );
            if (testRes.body == "Working") {
              vname = Timeline.now.toString() + '.mp4';
              //"${DateTime.now()}.mp4"
              final path = join((await getTemporaryDirectory()).path, vname);

              await _cameraController.startVideoRecording(path);
              setState(() {
                isRecording = true;
                //here is the recorded video
                videopath = path;
              });
            } else {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Server Error!"),
                  content: Text(
                      "Server is not responding at the moment. Please Try Again Later"),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Text("OK"))
                  ],
                ),
                barrierDismissible: false,
              );
            }
          } else {
            await _cameraController.stopVideoRecording();
            setState(() {
              isLoading = true;
              isRecording = false;
              text.text = 'Detecting ...';
              void SendVideo(String p) async {
                try {
                  var type_value = 'static';
                  if (type[0]) {
                    type_value = 'static';
                  } else if (type[1]) {
                    type_value = 'dynamic';
                  }
                  String url = ip + type_value;

                  // await VideoCompress.setLogLevel(0);
                  // compressed_video = await VideoCompress.compressVideo(p,
                  //     quality: VideoQuality.LowQuality, includeAudio: false);
                  // p = compressed_video!.path!;
                  // print(p);

                  var vid = FormData.fromMap({
                    'video': await mpf.MultipartFile.fromFile(p,
                        filename: vname,
                        contentType: MediaType('video', 'mp4')),
                  });

                  response = await dio.post(url, data: vid);

                  //response = await post(Uri.parse(url),

                  // headers: {
                  //   'Accept' : 'application/json',
                  //   'Content-Type': 'multipart/form-data'
                  // },
                  //body: jsonEncode({"vpath": p, "id": 2}));

                  //body: data);
                  check = response.data;
                  print("CHECKING RESPONSE DATA : " + check);
                  text.text = check;
                  if (text.text != 'Detecting ...' || text.text != "") {
                    setState(() {
                      isLoading = false;
                    });
                  }

                  print("CHECKING RESPONSE BODY : " + response.body);
                  print("CHECKING RESPONSE CODE : " + response.statusCode);
                } catch (er) {}
              }

              SendVideo(videopath);
            });
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => VideoPage(
            //             path: videopath,
            //           )),
            // );
          }
        },
        child: Stack(
          children: [
            CameraPreview(_cameraController),
            FutureBuilder(
                future: cameraValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_cameraController);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            Positioned(
              bottom: 0.0,
              child: Container(
                  color: Colors.black,
                  padding: EdgeInsets.only(
                    top: 50,
                    bottom: 60,
                  ),
                  width: MediaQuery.of(context).size.width),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: isRecording ? Colors.red : color,
                  child: Text(
                    isRecording
                        ? 'Double Tap to Stop Recording!'
                        : 'Double Tap to Start Recording!',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 90,
                  color: Colors.white,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: TextFormField(
                      maxLines: 2,
                      readOnly: true,
                      controller: text,
                      //cursorColor: Colors.white,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        // hintStyle: TextStyle(
                        //   fontSize: 18,
                        //   //color: Colors.black,
                        // ),
                        filled: true,
                        fillColor: Colors.white,
                        //focusColor: color,
                        contentPadding:
                            EdgeInsets.only(left: 14, right: 14, top: 25),
                        hintText: 'Text will appear here',
                        suffixIcon: IconButton(
                          onPressed: () async {
                            if (text.text != '') {
                              final filename = join(
                                  (await getExternalStorageDirectory())!.path,
                                  'Message.txt');
                              //Encoding in base64
                              // String encoded = stringToBase64.encode(text.text);
                              // print("Encoded in Base64 is : " + encoded);
                              // decoding from base64
                              // String decoded = stringToBase64.decode(encoded);
                              // print("Decoded from Base64 is : " + decoded);
                              var file = File(filename);
                              await file.writeAsString(text.text);
                              // var content = await file.readAsString();
                              // print("FILE DATA IS : " + content);
                              await Share.shareFiles([filename]);
                            } else {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  // title: Text("Sorry!"),
                                  content: Text(
                                      "Sorry! Please record a video of hand sign gestures first."),
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
                          iconSize: 30.0,
                          icon: Icon(
                            Icons.share,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : Center(),
          ],
        ),
      ),
    );
  }
}

// //For Taking a Picture
// void takePicture() async {
//   final path =
//       join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");
//   await _cameraController.takePicture(path);
// }

//Back button code
// IconButton(
//   icon: Icon(Icons.arrow_back_ios,
//     color: Colors.white, size: 28),
//   onPressed: () {
//   setState(() {
//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(
//     //       builder: (context) => Firstroute()),
//     // );
//   });
//   }),
