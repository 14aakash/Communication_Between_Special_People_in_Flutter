import 'package:flutter/material.dart';

class Texts extends StatelessWidget {
  const Texts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.green[100],
        child: Center(
            child: Text("All texts from Database will be displayed here")),
      ),
    );
  }
}
