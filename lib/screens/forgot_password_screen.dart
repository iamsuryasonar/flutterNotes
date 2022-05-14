import 'package:flutter/material.dart';
import 'package:jotdot/handler/auth_handler.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthHandler authInstance = AuthHandler();
    String email = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recover Password',
          style: TextStyle(
            color: Color.fromRGBO(103, 244, 148, 1),
            fontFamily: 'Jost',
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                cursorColor: Colors.grey[900],
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26, width: 0.0),
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey[900],
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w400,
                  ),
                  border: const OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Email',
                  suffixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.grey[900],
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey[900],
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onChanged: (value) {
                  email = value.trim();
                },
              ),
              const SizedBox(
                height: 30.0,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Colors.grey[900],
                    ),
                  ),
                  onPressed: () {
                    authInstance.passwordReset(email).then(
                      (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'email sent',
                              style: TextStyle(
                                fontFamily: 'Jost',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        );
                        Navigator.pop(context);
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
                  child: const Text(
                    "Send",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
