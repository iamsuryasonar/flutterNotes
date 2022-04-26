import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterapp/model/note.dart';
import 'package:flutterapp/handler/auth_handler.dart';

class CrudHandler {
  AuthHandler authInstance = AuthHandler();

  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref().child('/users');

  late DatabaseReference _notesRef;

  CrudHandler() {
    _notesRef =
        _usersRef.child(authInstance.getCurrentUserid()).child("/notes");
  }
  void addNote(Note note) async {
    //key for new child of notes route in firebase database
    String notekey;
    // check if note already contains the key
    // ie. if user is updating or creating a note.
    // if user is creating a note, index of that note will
    // be sent, therefore we should create new key for the 'notes' route of firebase db
    if (note.key == '') {
      // get unique key for the route - child notes
      notekey = _notesRef.push().key.toString();
      // put key value to a note
      note.key = notekey;
    } else {
      notekey = note.key;
    }
    // either user creates/updates the note we will
    // have to create timestamp to send to the db
    // it will be used as condition while sorting notes in notes screen
    note.timestamp = DateTime.now().millisecondsSinceEpoch;

    //set a note to firebase database - child notes
    await _notesRef.child(notekey).set(note.toJson());
  }

  Future<List<Note>> getNotes() async {
    List<Note> items = [];
    final snapshot = await _notesRef.get();
    if (snapshot.value != null) {
      final json = snapshot.value as Map<dynamic, dynamic>;
      json.forEach((key, value) {
        final result = Note.fromJson(value);
        items.add(result);
      });
    }
    return items;
  }

  deleteNote(String key) async {
    await _notesRef.child(key).remove();
  }
}
