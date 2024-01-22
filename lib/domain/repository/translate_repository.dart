import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../../data/model/language.dart';

abstract class TranslateRepository {
  Future<Either<Failure, String>> translateByWord(String text);

  Future<void> downloadLanguage();

  Future<void> downloadAllModel();

  Future<Either<Failure, String>> translateByTextRevert(String text);

  Future<List<Tuple2<String, bool>>> getSupportedLanguage();

  void changeTargetLanguage(Language newTargetLanguage);

  void changeSourceLanguage(Language newSourceLanguage);
}