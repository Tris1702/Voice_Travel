import 'package:flutter/material.dart' hide Ink;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:voice_travel/core/constance/supported_language.dart';

import '../model/language.dart';

class GoogleMLDigitalRecognition {

  final DigitalInkRecognizerModelManager _modelManager =
  DigitalInkRecognizerModelManager();

  late Language _sourceLanguage;
  late DigitalInkRecognizer _digitalInkRecognizer;

  GoogleMLDigitalRecognition() {
    changeModel(AppSupportedLanguage.english);
  }

  Future<bool> _isModelDownloaded() async {
    return await _modelManager.isModelDownloaded(_sourceLanguage.name) ? true: false;
  }

  Future<void> changeModel(Language newLanguage) async {
    _sourceLanguage = newLanguage;
    print("====> ${_sourceLanguage.code}");
    _digitalInkRecognizer = DigitalInkRecognizer(languageCode: _sourceLanguage.code);
  }

  Future<void> downloadAllModel() async {
    await _modelManager
        .downloadModel(AppSupportedLanguage.english.code).then((value) => print("====> Downloaded digital english"));
    await _modelManager
        .downloadModel(AppSupportedLanguage.vietnamese.code).then((value) => print("====> Downloaded digital viet"));
    await _modelManager
        .downloadModel(AppSupportedLanguage.chinese.code).then((value) => print("====> Downloaded digital china"));
    await _modelManager
        .downloadModel(AppSupportedLanguage.japanese.code).then((value) => print("====> Downloaded digital japan"));
    await _modelManager
        .downloadModel(AppSupportedLanguage.spanish.code).then((value) => print("====> Downloaded digital span"));
  }

  Future<bool> downloadModel() async {
    final isDownloaded = await _isModelDownloaded();
    if (!isDownloaded) {
      return await _modelManager
          .downloadModel(_sourceLanguage.code);
    }
    return true;
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