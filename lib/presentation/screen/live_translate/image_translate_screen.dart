import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voice_travel/presentation/screen/live_translate/gallery_bloc.dart';

class ImageTranslate extends StatefulWidget {
  const ImageTranslate({super.key});

  @override
  State<ImageTranslate> createState() => _ImageTranslateState();
}

class _ImageTranslateState extends State<ImageTranslate> {
  GalleryBloc bloc = GalleryBloc();

  void _showText(BuildContext context, String text, String translatedText) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Result"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text),
            const SizedBox(height: 10),
            Text(translatedText),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      )
  );

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await bloc.translateImageFromGallery(pickedFile.path).then((value) {
        String text = value.first;
        String translatedText = value.last;

        _showText(context, text, translatedText);
      });

    }
  }

  void _openCamera() => bloc.openCamera();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () => _openGallery(context),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(FontAwesomeIcons.image),
                SizedBox(width: 5,),
                Text("Gallery"),
              ],
            ),
        ),
        const SizedBox(height: 10,),
        ElevatedButton(
          onPressed: _openCamera,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(FontAwesomeIcons.camera),
              SizedBox(width: 5,),
              Text("Camera"),
            ],
          ),
        ),
      ],
    );
  }
}
