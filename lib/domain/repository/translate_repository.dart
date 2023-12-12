import 'package:dartz/dartz.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import '../../core/error/failure.dart';
import '../../data/model/word.dart';

abstract class TranslateRepository {
  Future<Either<Failure, String>> translateByWord(String text);

  Future<void> downloadLanguage(TranslateLanguage language);

  Future<Either<Failure, String>> translateByTextRevert(String text);
}