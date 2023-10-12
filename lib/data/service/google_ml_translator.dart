import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:voice_travel/core/error/failure.dart';
import 'package:dartz/dartz.dart';

class GoogleMLTranslator {
  TranslateLanguage _sourceLanguage = TranslateLanguage.english;
  TranslateLanguage _targetLanguage = TranslateLanguage.vietnamese;
  late final OnDeviceTranslator _onDeviceTranslator;
  late final _onDeviceTranslatorModelManager = OnDeviceTranslatorModelManager();

  GoogleMLTranslator() {
    _onDeviceTranslator = OnDeviceTranslator(sourceLanguage: _sourceLanguage, targetLanguage: _targetLanguage);
  }

  void changeSourceLanguage(TranslateLanguage newSourceLanguage) => _sourceLanguage = newSourceLanguage;

  void changeTargetLanguage(TranslateLanguage newTargetLanguage) => _targetLanguage = newTargetLanguage;

  Future<Either<Failure,String>> translateByText(String text) async {
    bool isDownloaded = await _onDeviceTranslatorModelManager.isModelDownloaded(_targetLanguage.bcpCode);
    if (isDownloaded) {
      return Right(await _onDeviceTranslator.translateText(text));
    } else {
      return Left(NotDownloadedYet());
    }
  }
}