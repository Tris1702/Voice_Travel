import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:voice_travel/core/bloc_base.dart';
import 'package:voice_travel/core/constance/supported_language.dart';
import 'package:voice_travel/data/model/translate_record.dart';
import 'package:voice_travel/data/service/database_service.dart';
import 'package:voice_travel/domain/repository/entity_extraction_repository.dart';
import 'package:voice_travel/presentation/router/app_router.dart';

import '../../../data/model/language.dart';
import '../../../domain/repository/digital_recognition_repository.dart';
import '../../../domain/repository/translate_repository.dart';

class TranslateBloc extends BlocBase {

  final translator = GetIt.I<TranslateRepository>();
  final recognizer = GetIt.I<DigitalRecognitionRepository>();
  final entityExtractor = GetIt.I<EntityExtractionRepository>();
  final database = GetIt.I<DatabaseService>();

  final sequencePoints = BehaviorSubject<List<List<Offset>>>.seeded(List.empty(growable: true));
  final recognizedText = BehaviorSubject<List<String>>.seeded(List.empty(growable: true));
  final extractedEntities = BehaviorSubject<List<EntityAnnotation>>.seeded(List.empty(growable: true));
  final isWriting = PublishSubject<bool>();

  TextEditingController inputTextController = TextEditingController();
  TextEditingController outputTextController = TextEditingController();

  Language sourceLanguage = AppSupportedLanguage.english;
  Language targetLanguage = AppSupportedLanguage.vietnamese;

  late FlutterTts flutterTts;
  @override
  void dispose() {
    inputTextController.dispose();
    outputTextController.dispose();
  }

  @override
  void init() async {
    flutterTts = FlutterTts();
    await flutterTts.getLanguages;
    await flutterTts.getVoices;
    isWriting.add(false);
  }

  void copyInputText() async {
    await Clipboard.setData(ClipboardData(text: inputTextController.text));
    Fluttertoast.showToast(msg: 'Copied');
  }

  void copyOutputText() async {
    await Clipboard.setData(ClipboardData(text: outputTextController.text));
    Fluttertoast.showToast(msg: 'Copied');
  }

  void readInputText() => readOutLoud(inputTextController.text);
  void readOutputText() => readOutLoud(outputTextController.text);

  Future<void> readOutLoud(String? text) async {
    if (text == null) return;
    flutterTts.speak(text);
    await flutterTts.awaitSpeakCompletion(true);
  }

  void translate() async {
    print("===> translating....");
    await translator.translateByWord(inputTextController.text).then((result) {
      result.fold(
              (l) => outputTextController.text = inputTextController.text,
              (r) => outputTextController.text = r,
      );
    });

    extractEntities();
  }

  void undo() {
    if (sequencePoints.value.isNotEmpty) {
      sequencePoints.value.removeLast();
      sequencePoints.add(sequencePoints.value);
    }
  }

  void updateSequencePoints(Offset location) {
    sequencePoints.value.last.add(location);
    sequencePoints.add(sequencePoints.value.toList());
  }

  void addWord(String word) {
    inputTextController.text = '${inputTextController.text} $word';
    sequencePoints.value = [];
    sequencePoints.add(sequencePoints.value.toList());
    translate();
  }

  void addSpace() => inputTextController.text = '${inputTextController.text} ';

  void deleteLastText() {
    List<String> words = inputTextController.text.split(' ');
    words.removeLast();
    inputTextController.text = words.join(' ');
  }

  void changeWritingState(bool? state) async => isWriting.add(state?? !(await isWriting.last));

  void navigateBack() => appNavigator.pop();

  void recognitionText() async {
    await recognizer.recognizeText(sequencePoints.value).then((value) {
      recognizedText.value = value;
      recognizedText.add(recognizedText.value);
    });
  }

  void extractEntities() async {
    print("===> extracting...");
    List<EntityAnnotation> inputEntities = await entityExtractor.extractEntities(inputTextController.text);
    // List<EntityAnnotation> outputEntities = await entityExtractor.extractEntities(outputTextController.text);
    print("===> extracted ${inputEntities.length}");
    extractedEntities.value = inputEntities;
    extractedEntities.sink.add(extractedEntities.value);
  }

  void addToFavourite() {
    database.addFav(TranslateRecord(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage, sourceText: inputTextController.text, targetText: outputTextController.text)).then((_) =>
      Fluttertoast.showToast(msg: "Added to favourite")
    );
  }

  void navigateToHistory() {
    appNavigator.pushed(AppRoute.history);
  }
}