import 'package:flutter/material.dart';
import 'package:flutterapp/handler/auth_handler.dart';
import 'package:flutterapp/screens/login_screen.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthHandler authInstance = AuthHandler();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color.fromRGBO(103, 244, 148, 1),
          ),
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Delete account",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton.icon(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 12.0),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.grey[900],
                      ),
                    ),
                    onPressed: () {
                      authInstance.deleteAccount().then(
                        (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Account Deleted",
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LogIn(),
                            ),
                          );
                        },
                        onError: (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.delete_forever_rounded,
                      size: 25.0,
                      color: Colors.red[600],
                    ),
                    label: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.red[600],
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
