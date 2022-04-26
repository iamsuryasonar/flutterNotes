import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterapp/model/note.dart';
import 'package:flutterapp/handler/auth_handler.dart';
import 'package:flutterapp/handler/crud_handler.dart';
import 'package:flutterapp/screens/about_screen.dart';
import 'package:flutterapp/screens/add_view_notes_screen.dart';
import 'package:flutterapp/screens/login_screen.dart';
import 'package:flutterapp/screens/settings_screen.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  AuthHandler authInstance = AuthHandler();
  List<Note> allitems = [];
  dynamic db;
  late CrudHandler crudInstance;

  getNotes() {
    crudInstance = CrudHandler();
    db = crudInstance.getNotes();
    setState(() {
      db = crudInstance.getNotes();
    });
  }

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(
            fontFamily: 'Jost',
            fontWeight: FontWeight.w800,
            color: Color.fromRGBO(103, 244, 148, 1),
          ),
        ),
        backgroundColor: Colors.grey[900],
        actions: [
          PopupMenuButton(
            color: Colors.grey[900],
            elevation: 0.0,
            child: const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(Icons.more_vert),
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Container(
                    margin: const EdgeInsets.only(top: 60.0),
                    width: 120.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.settings),
                        Text(
                          'Settings',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Jost',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  value: 0,
                ),
                PopupMenuItem(
                  child: Container(
                    margin: const EdgeInsets.only(top: 30.0),
                    width: 120.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.speaker_notes_outlined),
                        Text(
                          'About',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Jost',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Container(
                    margin: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                    width: 120.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.logout_rounded),
                        Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Jost',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  value: 2,
                ),
              ];
            },
            onSelected: (result) {
              // onTap LogOut
              if (result == 2) {
                authInstance.logout().then(
                  (value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LogIn(),
                      ),
                    );
                  },
                );
              }
              // onTap Settings
              if (result == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              }
              // onTap About
              if (result == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const About()),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNotes()),
          ).then((data) {
            getNotes();
          });
        },
        backgroundColor: const Color.fromRGBO(103, 244, 148, 1),
        child: const Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: RefreshIndicator(
        onRefresh: () async {
          return await getNotes();
        },
        color: Colors.white,
        backgroundColor: Colors.grey[900],
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: FutureBuilder<List<Note>>(
              future: db,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  allitems = snapshot.data;
                  if (allitems.isEmpty) {
                    return const Text(
                      "No notes to display",
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w800,
                      ),
                    );
                  }
                  // sort notes depending on the timestamp of creation
                  allitems.sort((a, b) => b.timestamp.compareTo(a.timestamp));

                  return MasonryGridView.count(
                      itemCount: allitems.length,
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      itemBuilder: (context, index) {
                        return Card(
                          // color: const Color.fromRGBO(247, 247, 247, 1),
                          color: Color(
                              int.parse(allitems[index].noteColor, radix: 16)),
                          child: Dismissible(
                            key: Key(allitems[index].key),
                            onDismissed: (direction) {
                              crudInstance.deleteNote(allitems[index].key);
                              if (allitems.isEmpty) {
                                return;
                              }
                              setState(() {
                                allitems.remove(allitems[index]);
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'note deleted',
                                    style: TextStyle(
                                      fontFamily: 'Jost',
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              );
                            },
                            background: Container(
                              color: Colors.red,
                              child: const Align(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(
                                    top: 6.0, bottom: 6.0),
                                child: Text(
                                  allitems[index].title,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'Jost',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(bottom: 6.0),
                                child: Text(
                                  allitems[index].note,
                                  maxLines: 10,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Jost',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              onTap: () {
                                //edit note
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddNotes(
                                      title: allitems[index].title,
                                      note: allitems[index].note,
                                      index: allitems[index].key,
                                      timestamp: 0,
                                      noteColor: allitems[index].noteColor,
                                    ),
                                  ),
                                ).then((data) {
                                  getNotes();
                                });
                              },
                            ),
                          ),
                        );
                      });
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}
