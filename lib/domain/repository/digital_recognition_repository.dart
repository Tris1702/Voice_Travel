import 'dart:ui';

abstract class DigitalRecognitionRepository {
  Future<List<String>> recognizeText(List<List<Offset>> inputPoint);
}