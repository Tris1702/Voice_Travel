import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_travel/core/bloc_base.dart';
import 'package:voice_travel/domain/repository/entity_extraction_repository.dart';

import '../../../data/model/language.dart';
import '../../../domain/repository/translate_repository.dart';

class VoiceBloc extends BlocBase {

  final translator = GetIt.I<TranslateRepository>();
  final extractor = GetIt.I<EntityExtractionRepository>();
  late Language sourceLanguage;
  late Language targetLanguage;


  BehaviorSubject<List<Entity>> annotations = BehaviorSubject<List<Entity>>.seeded(List.empty(growable: true));
  PublishSubject<bool> isListening = PublishSubject();

  final sequencePoints = BehaviorSubject<List<List<Offset>>>.seeded(List.empty(growable: true));

  TextEditingController inputTextController = TextEditingController(text: "Tap the mic button to start");
  TextEditingController outputTextController = TextEditingController(text: "Nhấn vào mic để bắt đầu");

  SpeechToText speech = SpeechToText();
  late FlutterTts flutterTts;
  bool isAvailable = false;
  String words = '';

  @override
  void dispose() {
    inputTextController.dispose();
    outputTextController.dispose();
    speech.cancel();
  }

  @override
  void init() async {
    flutterTts = FlutterTts();
    speech.initialize().then((value) {
      isAvailable = value;
      print("====> ok isAvailable: $isAvailable");
      isListening.add(false);
    } );
    await flutterTts.getLanguages;
    await flutterTts.getVoices;
  }

  void translate(String word) async {
    await translator.translateByWord(word).then((result) {
      result.fold(
            (l) => outputTextController.text = inputTextController.text,
            (r) => outputTextController.text = r,
      );
    });
  }

  void navigateBack() => appNavigator.pop();

  void copyInputText() async {
    await Clipboard.setData(ClipboardData(text: inputTextController.text));
    Fluttertoast.showToast(msg: 'Copied');
  }

  void copyOutputText() async {
    await Clipboard.setData(ClipboardData(text: outputTextController.text));
    Fluttertoast.showToast(msg: 'Copied');
  }

  void readInputText() => readOutLoud(sourceLanguage.code, inputTextController.text);
  void readOutputText() => readOutLoud(targetLanguage.code, outputTextController.text);

  Future<void> readOutLoud(String languageCode, String? text) async {
    if (text == null) return;
    await flutterTts.setLanguage(languageCode);
    flutterTts.speak(text);
    await flutterTts.awaitSpeakCompletion(true);
  }

  void stopListening() async {
    speech.stop().then((_) => isListening.add(false));

  }

  void startListening() {
    print("===> $isAvailable");
    if (!isAvailable) return;
    print("===> listening ...");
    isListening.add(true);
    speech.listen(
        onResult: (result) => _onSpeechResult(result),
        localeId: sourceLanguage.code,
    );
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    words = result.recognizedWords;
    inputTextController.text = words;
    translate(words);
  }

  void extractEntity() async {
    List<EntityAnnotation> result = await extractor.extractEntities(inputTextController.text);
    annotations.add(result.first.entities);
  }
}