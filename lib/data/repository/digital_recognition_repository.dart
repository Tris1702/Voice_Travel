import 'dart:ui';

import 'package:get_it/get_it.dart';
import 'package:voice_travel/data/service/google_ml_digital_ink_recognition.dart';

import '../../domain/repository/digital_recognition_repository.dart';

class DigitalRecognitionRepositoryImpl implements DigitalRecognitionRepository {
  final GoogleMLDigitalRecognition recognizer = GetIt.I<GoogleMLDigitalRecognition>();

  @override
  Future<List<String>> recognizeText(List<List<Offset>> inputPoint) => recognizer.recognizeText(inputPoint);

}