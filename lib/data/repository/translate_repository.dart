import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:voice_travel/core/error/failure.dart';
import 'package:voice_travel/data/model/language.dart';
import 'package:voice_travel/data/model/translate_record.dart';
import 'package:voice_travel/data/service/google_ml_translator.dart';

import '../../domain/repository/translate_repository.dart';

class TranslateRepositoryImpl implements TranslateRepository {
  final GoogleMLTranslator _translator = GetIt.I<GoogleMLTranslator>();

  @override
  Future<Either<Failure, String>> translateByWord(String text) => _translator.translateByText(text);

  @override
  Future<void> downloadLanguage() => _translator.downloadLanguage();

  @override
  Future<Either<Failure, String>> translateByTextRevert(String text) => _translator.translateByTextRevert(text);

  @override
  Future<List<Tuple2<String, bool>>> getSupportedLanguage() => _translator.getSupportedLanguage();

  @override
  void changeSourceLanguage(Language newSourceLanguage) => _translator.changeSourceLanguage(newSourceLanguage);

  @override
  void changeTargetLanguage(Language newTargetLanguage) => _translator.changeTargetLanguage(newTargetLanguage);

  @override
  Future<void> downloadAllModel() => _translator.downloadAllModel();
}