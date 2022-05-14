import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jotdot/model/note.dart';
import 'package:jotdot/handler/auth_handler.dart';

class CrudHandler {
  AuthHandler authInstance = AuthHandler();

  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.ref().child('/users');

  late DatabaseReference _notesRef;
  final _firebaseStorage = FirebaseStorage.instance;

  CrudHandler() {
    _notesRef =
        _usersRef.child(authInstance.getCurrentUserid()).child("/notes");
  }
  Future addNote(Note note, {var file}) async {
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
    await _notesRef.child(notekey).update({
      'key': note.key,
      'timestamp': note.timestamp,
      'note': note.note,
      'noteColor': note.noteColor,
      'title': note.title,
    });

    // upload image

    if (file != null) {
      var snapshot = await _firebaseStorage
          .ref()
          .child('notesimages/${note.key}/${note.timestamp}')
          .putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();

      await _notesRef.child(notekey).child('images').push().set(downloadUrl);
    }
  }

  Future<List<Note>> getNotes() async {
    List<Note> items = [];
    final snapshot = await _notesRef.get();
    if (snapshot.value != null) {
      final json = snapshot.value as Map<dynamic, dynamic>;
      //iterate over Map to convert each into Note instance
      json.forEach((key, value) {
        Map<dynamic, dynamic> map = {};
        // List<dynamic> listOfImages = [];
        Map<dynamic, dynamic> listOfImages = {};
        if (value['images'] != null) {
          // convert images Map to list
          value['images'].forEach((k, v) {
            // listOfImages.add(v);
            final newEntry = <String, String>{k: v};
            listOfImages.addEntries(newEntry.entries);
          });
        }
        //modify the map to replace images Map to a List
        map = {
          'key': value['key'],
          'note': value['note'],
          'title': value['title'],
          'timestamp': value['timestamp'],
          'noteColor': value['noteColor'],
          'images': listOfImages,
        };
        //convert to a Note instance
        final result = Note.fromJson(map);
        items.add(result);
      });
    }
    return items;
  }

  deleteNote(String key) async {
    await FirebaseStorage.instance
        .ref("notesimages/$key/")
        .listAll()
        .then((value) {
      for (var element in value.items) {
        FirebaseStorage.instance.ref(element.fullPath).delete();
      }
    });
    await _notesRef.child(key).remove();
  }

  Future deleteImage(String noteKey, String imageKey, String imageurl) async {
    await _notesRef.child(noteKey).child('images').child(imageKey).remove();
    await FirebaseStorage.instance.refFromURL(imageurl).delete();
  }
}
