import 'dart:ui';

import '../../data/model/language.dart';

abstract class DigitalRecognitionRepository {
  Future<bool> downloadModel();
  Future<List<String>> recognizeText(List<List<Offset>> inputPoint);
  void changeSourceLanguage(Language newLanguage);
  Future<void> downloadAllModel();
}