import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/handler/crud_handler.dart';
import 'package:flutterapp/model/note.dart';
import 'package:flutterapp/screens/image_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class AddNotes extends StatefulWidget {
  final String? title;
  final String? note;
  final String? index;
  final int? timestamp;
  final String? noteColor;
  final List<dynamic>? listOfImages;
  const AddNotes(
      {Key? key,
      this.title,
      this.note,
      this.index,
      this.timestamp,
      this.noteColor,
      this.listOfImages})
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
  List<dynamic>? listOfImages = [];
  var file;
  bool _loading = false;

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
    if (widget.listOfImages == null) {
      listOfImages = [];
    } else {
      listOfImages = widget.listOfImages;
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
            highlightColor: Colors.green,
            splashColor: Colors.green,
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
              highlightColor: Colors.green,
              splashColor: Colors.green,
              onPressed: () async {
                final _imagePicker = ImagePicker();
                XFile? image;
                //Check Permissions
                await Permission.photos.request();

                var permissionStatus = await Permission.photos.status;

                if (permissionStatus.isGranted) {
                  //Select Image
                  image =
                      await _imagePicker.pickImage(source: ImageSource.gallery);

                  file = await File(image!.path).create();
                }
              },
              icon: const Icon(Icons.add_photo_alternate_rounded)),
          IconButton(
              highlightColor: Colors.green,
              splashColor: Colors.green,
              onPressed: () async {
                var data = await rootBundle.load("fonts/Jost.ttf");
                var myFont = pw.Font.ttf(data);
                final pdf = pw.Document();

                pdf.addPage(
                  pw.Page(
                    pageFormat: PdfPageFormat.a4,
                    build: (pw.Context context) {
                      return pw.Center(
                        child: pw.Column(
                          children: [
                            pw.Text(
                              title,
                              style: pw.TextStyle(font: myFont, fontSize: 18),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Wrap(children: [
                              pw.Text(
                                note,
                                style: pw.TextStyle(font: myFont, fontSize: 14),
                              ),
                            ]),
                          ],
                        ),
                      );
                    },
                  ),
                );

                String documentsPath = '/storage/emulated/0/Documents';
                var filepath = '$documentsPath/$title.pdf';
                final file = File(filepath);
                await file.writeAsBytes(await pdf.save());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(
                      seconds: 1,
                    ),
                    content: Text('Pdf saved'),
                  ),
                );
              },
              icon: const Icon(Icons.download_for_offline_sharp)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(25.0),
        child: FloatingActionButton.extended(
          onPressed: () async {
            try {
              setState(() {
                _loading = true;
              });
              final newnote = Note(key, title, note, timestamp, noteColor);
              await crudInstance.addNote(newnote, file: file);
              setState(() {
                _loading = false;
              });
              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$e'),
                ),
              );
            }
          },
          label: (_loading == true)
              ? const Text(
                  'Saving',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w800,
                  ),
                )
              : const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w800,
                  ),
                ),
          icon: (_loading == true)
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Icon(
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
            (listOfImages != null && listOfImages!.isNotEmpty)
                // ? Container(
                //     child: PhotoViewGallery.builder(
                //       scrollPhysics: const BouncingScrollPhysics(),
                //       builder: (BuildContext context, int index) {
                //         return PhotoViewGalleryPageOptions(
                //           imageProvider:
                //               AssetImage(widget.listOfImages?[index]),
                //           initialScale: PhotoViewComputedScale.contained * 0.8,
                //           heroAttributes: PhotoViewHeroAttributes(
                //               tag: listOfImages?[index]),
                //         );
                //       },
                //       itemCount: listOfImages?.length,
                //       loadingBuilder: (context, event) => Center(
                //         child: Container(
                //           width: 20.0,
                //           height: 20.0,
                //           child: const CircularProgressIndicator(
                //               // value: event == null
                //               //     ? 0
                //               //     : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                //               ),
                //         ),
                //       ),
                //       // backgroundDecoration: widget.backgroundDecoration,
                //       // pageController: widget.pageController,
                //       // onPageChanged: onPageChanged,
                //     ),
                //   )

                ? SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listOfImages?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            print(listOfImages?[index]);
                            //navigate to display full image
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageScreen(
                                  image: listOfImages?[index],
                                ),
                              ),
                            );
                          },
                          onLongPress: () {},
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: NetworkImage(
                              (listOfImages?[index]),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const SizedBox(
                    width: double.infinity,
                    height: 0,
                  ),
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
                    fontSize: 18.0,
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w800,
                    color: Colors.black87),
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
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}
