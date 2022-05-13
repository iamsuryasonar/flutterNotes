import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageScreen extends StatefulWidget {
  final String image;
  const ImageScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  String image = '';
  @override
  Widget build(BuildContext context) {
    image = widget.image.toString();
    return Center(
      child: PhotoView(
        imageProvider: NetworkImage(image),
      ),
    );
  }
}
