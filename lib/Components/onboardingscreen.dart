import 'package:cbsp_gui/SignToText/CameraPage.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/globals.dart' as globals;

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final pageViewController = PageController();
  bool isLastPage = false;
  @override
  void dispose() {
    // TODO: implement dispose
    pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          controller: pageViewController,
          children: [
            Container(
              color: Colors.red,
              child: const Center(child: Text('Page 1')),
            ),
            Container(
              color: Colors.blue,
              child: const Center(child: Text('Page 2')),
            ),
            Container(
              color: Colors.yellow,
              child: const Center(child: Text('Page 3')),
            )
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                primary: Colors.white,
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(80),
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('firstscreen', true);
                globals.firstscreen = true;
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const CameraPage()));
              },
              child: const Text(
                'Get Started',
                style: TextStyle(fontSize: 24),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text('SKIP'),
                    onPressed: () => pageViewController.jumpToPage(2),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: pageViewController,
                      count: 3,
                      onDotClicked: (index) => pageViewController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      ),
                    ),
                  ),
                  TextButton(
                    child: const Text('NEXT'),
                    onPressed: () => pageViewController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut),
                  ),
                ],
              ),
            ),
    );
  }
}
