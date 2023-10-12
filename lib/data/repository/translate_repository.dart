import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:voice_travel/core/error/failure.dart';
import 'package:voice_travel/data/model/national.dart';
import 'package:voice_travel/data/model/word.dart';
import 'package:voice_travel/data/service/google_ml_translator.dart';

import '../../domain/repository/translate_repository.dart';

class TranslateRepositoryImpl implements TranslateRepository {
  final GoogleMLTranslator _translator = GetIt.I<GoogleMLTranslator>();

  @override
  Future<Either<Failure, String>> translateByWord(String text) => _translator.translateByText(text);

}