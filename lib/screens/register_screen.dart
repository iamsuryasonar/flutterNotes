import 'package:flutter/material.dart';
import 'package:jotdot/handler/auth_handler.dart';
import 'package:jotdot/screens/login_screen.dart';
import 'package:jotdot/screens/notes_screen.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  AuthHandler authInstance = AuthHandler();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String username = '';
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
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
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30.0,
                ),
                TextField(
                  cursorColor: Colors.grey[900],
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
                    labelText: 'Username',
                    suffixIcon: Icon(
                      Icons.person_pin,
                      color: Colors.grey[900],
                    ),
                    hintText: 'Username',
                    hintStyle: TextStyle(
                      color: Colors.grey[900],
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  onChanged: (value) {
                    username = value.trim();
                  },
                ),
                const SizedBox(
                  height: 30.0,
                ),
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
                TextField(
                  cursorColor: Colors.grey[900],
                  obscureText: !_isPasswordVisible,
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
                    labelText: 'Password',
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        Icons.password_outlined,
                        color: !_isPasswordVisible
                            ? Colors.grey[900]
                            : Colors.green,
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey[900],
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey[900],
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                        });

                        authInstance.register(username, email, password).then(
                          (_) {
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Notes(),
                              ),
                            );
                          },
                          onError: (error) {
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error),
                              ),
                            );
                          },
                        );
                      },
                      child: _isLoading
                          ? const SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ))
                          : const Text(
                              'Register',
                              style: TextStyle(
                                fontFamily: 'Jost',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        foregroundColor: MaterialStateProperty.all(
                          const Color.fromRGBO(103, 244, 148, 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LogIn(),
                          ),
                        );
                      },
                      child: const Text(
                        'Privacy policy',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Already a User?",
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        foregroundColor: MaterialStateProperty.all(
                          const Color.fromRGBO(103, 244, 148, 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LogIn(),
                          ),
                        );
                      },
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
