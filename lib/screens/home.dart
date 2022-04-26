import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hello',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: Colors.grey[900],
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'Home Screen',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 30,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const SecondScreen()),
              // );
            },
            child: const Text(
              'click',
              style: TextStyle(fontSize: 25.0),
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(239, 0, 0, 0),
    );
  }
}
