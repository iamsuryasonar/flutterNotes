import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterapp/handler/crud_handler.dart';
import 'package:flutterapp/model/note.dart';

class AddNotes extends StatefulWidget {
  final String? title;
  final String? note;
  final String? index;
  final int? timestamp;
  final String? noteColor;
  const AddNotes(
      {Key? key,
      this.title,
      this.note,
      this.index,
      this.timestamp,
      this.noteColor})
      : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  String title = '';
  String note = '';
  String key = '';
  int timestamp = 0;
  String noteColor = 'ff97F2F3';

  final CrudHandler crudInstance = CrudHandler();
  FirebaseDatabase database = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    if (widget.index == null) {
      key = '';
    } else {
      key = widget.index.toString();
    }
    if (widget.title == null) {
      title = '';
    } else {
      title = widget.title.toString();
    }
    if (widget.note == null) {
      note = '';
    } else {
      note = widget.note.toString();
    }
    if (widget.timestamp == null) {
      timestamp = 0;
    } else {
      timestamp = widget.timestamp!.toInt();
    }
    if (widget.noteColor == null) {
      noteColor = 'ff97F2F3';
    } else {
      noteColor = widget.noteColor.toString();
    }
    ValueNotifier<String> changedColor = ValueNotifier(noteColor);

    List<String> noteColors = [
      'ffF3D1DC',
      'ffFEADB9',
      'ffFCF0CF',
      'ffF1E0B0',
      'ffFDCF76',
      'ffFFBFA3',
      'ffECAD8F',
      'ffC3E4FD',
      'ff97F2F3',
      'ffC5D7C0',
      'ffC1CD97',
      'ffD3C0F9',
      'ff9799BA'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add notes',
          style: TextStyle(
            color: Color.fromRGBO(103, 244, 148, 1),
            fontFamily: 'Jost',
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.grey[900],
      ),
      bottomSheet: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height:
                          MediaQuery.of(context).copyWith().size.height * 0.20,
                      child: Column(children: [
                        const SizedBox(height: 20.0),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 0.0),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Colors",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Jost',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: noteColors.map((value) {
                                return IconButton(
                                  onPressed: () {
                                    changedColor.value = value;
                                    noteColor = value;
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.circle),
                                  color: Color(int.parse(value, radix: 16)),
                                  iconSize: 50.0,
                                );
                              }).toList()),
                        ),
                      ]),
                    );
                  });
            },
            icon: ValueListenableBuilder(
              valueListenable: changedColor,
              builder: (context, value, child) {
                return Icon(
                  Icons.color_lens_rounded,
                  color: Color(int.parse(value.toString(), radix: 16)),
                );
              },
            ),
            // const Icon(Icons.color_lens_rounded),
            // color: Color(int.parse(changedColor.value, radix: 16)),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_photo_alternate_rounded)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(25.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            try {
              final newnote = Note(key, title, note, timestamp, noteColor);
              crudInstance.addNote(newnote);
              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$e'),
                ),
              );
            }
          },
          label: const Text(
            'Save',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Jost',
              fontWeight: FontWeight.w800,
            ),
          ),
          icon: const Icon(
            Icons.add,
            size: 25.0,
          ),
          backgroundColor: const Color.fromRGBO(103, 244, 148, 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextField(
              style: const TextStyle(
                fontSize: 25.0,
                fontFamily: 'Jost',
                fontWeight: FontWeight.w800,
              ),
              cursorColor: Colors.grey[900],
              controller: TextEditingController(text: title),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Title',
                hintStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black54,
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w800,
                ),
              ),
              onChanged: (value) {
                title = value;
              },
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: TextField(
                style: const TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.w800,
                ),
                cursorColor: Colors.grey[900],
                controller: TextEditingController(text: note),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your note here...',
                  hintStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54,
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onChanged: (value) {
                  note = value;
                },
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
