import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:voice_travel/core/error/failure.dart';
import 'package:voice_travel/data/model/word.dart';
import 'package:voice_travel/domain/repository/translate_repository.dart';

class TranslateByTextUseCase {
  final TranslateRepository _translateRepository = GetIt.I<TranslateRepository>();

  Future<Either<Failure, String>> translateByText(String text) => _translateRepository.translateByWord(text);
}