import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(
            color: Color.fromRGBO(103, 244, 148, 1),
            fontFamily: 'Jost',
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: const Center(
        child: Text(
          "About screen",
          style: TextStyle(
            fontFamily: 'Jost',
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
