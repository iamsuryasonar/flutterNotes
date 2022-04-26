import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterapp/model/note.dart';
import 'package:flutterapp/screens/about_screen.dart';
import 'package:flutterapp/screens/add_view_notes_screen.dart';
import 'package:flutterapp/screens/forgot_password_screen.dart';
import 'package:flutterapp/screens/login_screen.dart';
import 'package:flutterapp/screens/notes_screen.dart';
import 'package:flutterapp/screens/register_screen.dart';
import 'package:flutterapp/screens/settings_screen.dart';
import 'package:flutterapp/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn =
        FirebaseAuth.instance.currentUser?.uid == null ? false : true;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.yellow[700]),
        onGenerateRoute: generateRoute,
        // home route is Notes if user is logged in else Register
        home: isLoggedIn ? const Notes() : const Register());
  }
}

// static Route<dynamic> generateRoute(RouteSettings settings) {} in classRouteGenerator
Route<dynamic>? generateRoute(RouteSettings settings) {
  final args = settings.arguments;

  // middleware to check if user is offline, given a route
  onlineAuthGuard(Widget route) {
    return FirebaseAuth.instance.currentUser?.uid == null
        ? const LogIn()
        : route;
  }

  switch (settings.name) {
    //splash screen route
    case '/':
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    // login screen
    case '/login':
      return MaterialPageRoute(builder: (_) => const LogIn());
    //register screen
    case '/register':
      return MaterialPageRoute(builder: (_) => const Register());
    // forgot password screen
    case '/forgotpassword':
      return MaterialPageRoute(builder: (_) => const ForgotPassword());
    // add and view note screen
    case '/add_view_note':
      if (args is Note) {
        return MaterialPageRoute(
            builder: (_) => onlineAuthGuard(
                  AddNotes(
                      title: args.title,
                      note: args.note,
                      index: args.key,
                      timestamp: args.timestamp,
                      noteColor: args.noteColor),
                ));
      }
      return MaterialPageRoute(
          builder: (_) => onlineAuthGuard(const AddNotes(
              title: '', note: '', index: '', timestamp: 0, noteColor: '')));
    // notes screen
    case '/notes':
      return MaterialPageRoute(builder: (_) => onlineAuthGuard(const Notes()));
    // about screen
    case '/about':
      return MaterialPageRoute(builder: (_) => onlineAuthGuard(const About()));
    //settings screen
    case '/settings':
      return MaterialPageRoute(
          builder: (_) => onlineAuthGuard(const Settings()));
    default:
      //return splash screen if route does not matches any of above route
      return MaterialPageRoute(builder: (_) => const SplashScreen());
  }
}

// Colors------->>>>>
// Colors.grey[900] {black color}: Cursor Color, Hint, Suffix icon, Label text, Elevated Button background, AppBar background
// Colors.black26 {light grey}: border side outline
//  Color.fromRGBO(103, 244, 148, 1) {shade of green}: Text Button color, App Bar title, FloatingActionButton background .
// Color.fromARGB(255, 247, 247, 247) {Lightest grey}: card background,
