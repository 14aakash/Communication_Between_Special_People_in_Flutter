import 'package:flutter/material.dart';

class Signs extends StatelessWidget {
  const Signs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.red[100],
        child: Center(
            child: Text("All signs from Database will be displayed here")),
      ),
    );
  }
}
