import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../../data/model/word.dart';

abstract class TranslateRepository {
  Future<Either<Failure, String>> translateByWord(String text);
}