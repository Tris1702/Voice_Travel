import 'package:flutter/material.dart' hide Ink;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';

class GoogleMLDigitalRecognition {

  final DigitalInkRecognizerModelManager _modelManager =
  DigitalInkRecognizerModelManager();

  final _language = 'en';
  final _digitalInkRecognizer = DigitalInkRecognizer(languageCode: 'en');

  GoogleMLDigitalRecognition() {
    _isModelDownloaded().then((value) {
      print("isModelDownloaded: $value");
      if (!value) _downloadModel();
      return;
    });
  }

  Future<bool> _isModelDownloaded() async {
    return await _modelManager.isModelDownloaded(_language) ? true: false;
  }

  Future<void> _downloadModel() async {
    print("downloading model ...");
    Fluttertoast.showToast(msg: 'Downloading model...');
    _modelManager
        .downloadModel(_language)
        .then((value) => value
        ? Fluttertoast.showToast(msg: 'success')
        : Fluttertoast.showToast(msg:'failed'));
    print("download done ...");
  }

  Future<List<String>> recognizeText(List<List<Offset>> inputList) async {
    final ink = await convertOffsetToInk(inputList);
    List<String> recognizedText = [];
    try {
      final candidates = await _digitalInkRecognizer.recognize(ink);
      for (final candidate in candidates) {
        recognizedText.add(candidate.text);
      }
      return recognizedText;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return [];
    }
  }

  Future<Ink> convertOffsetToInk(List<List<Offset>> inputList) async {
    final ink = Ink();
    for (var listOffset in inputList) {
      ink.strokes.add(Stroke());
      final stockPoint = List<StrokePoint>.empty(growable: true);
      for (var element in listOffset) {
        stockPoint.add(StrokePoint(
            x: element.dx,
            y: element.dy,
            t: DateTime
                .now()
                .millisecondsSinceEpoch
        ));
      }
      ink.strokes.last.points = stockPoint;
    }

    return ink;
  }


}