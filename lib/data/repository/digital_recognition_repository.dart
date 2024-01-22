import 'dart:ui';

import 'package:get_it/get_it.dart';
import 'package:voice_travel/data/model/language.dart';
import 'package:voice_travel/data/service/google_ml_digital_ink_recognition.dart';

import '../../domain/repository/digital_recognition_repository.dart';

class DigitalRecognitionRepositoryImpl implements DigitalRecognitionRepository {
  final GoogleMLDigitalRecognition recognizer = GetIt.I<GoogleMLDigitalRecognition>();

  @override
  Future<List<String>> recognizeText(List<List<Offset>> inputPoint) => recognizer.recognizeText(inputPoint);

  @override
  Future<bool> downloadModel() => recognizer.downloadModel();

  @override
  Future<void> downloadAllModel() => recognizer.downloadAllModel();

  @override
  void changeSourceLanguage(Language newLanguage) => recognizer.changeModel(newLanguage);
}