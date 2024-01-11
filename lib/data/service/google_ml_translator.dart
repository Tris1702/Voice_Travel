import 'package:get/utils.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:voice_travel/core/constance/supported_language.dart';
import 'package:voice_travel/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:voice_travel/data/model/language.dart';

class GoogleMLTranslator {
  late Language _sourceLanguage;
  late Language _targetLanguage;
  late OnDeviceTranslator _onDeviceTranslator;
  late OnDeviceTranslator _onDeviceTranslator2;
  late final _onDeviceTranslatorModelManager = OnDeviceTranslatorModelManager();

  GoogleMLTranslator() {
    _sourceLanguage = AppSupportedLanguage.english;
    _targetLanguage = AppSupportedLanguage.vietnamese;
    _onDeviceTranslator = OnDeviceTranslator(sourceLanguage: _sourceLanguage.toTranslateLanguage(), targetLanguage: _targetLanguage.toTranslateLanguage());
    _onDeviceTranslator2 = OnDeviceTranslator(sourceLanguage: _targetLanguage.toTranslateLanguage(), targetLanguage: _sourceLanguage.toTranslateLanguage());
  }

  void changeSourceLanguage(Language newSourceLanguage) {
    _sourceLanguage = newSourceLanguage;
    _onDeviceTranslator = OnDeviceTranslator(sourceLanguage: _sourceLanguage.toTranslateLanguage(), targetLanguage: _targetLanguage.toTranslateLanguage());
    _onDeviceTranslator2 = OnDeviceTranslator(sourceLanguage: _targetLanguage.toTranslateLanguage(), targetLanguage: _sourceLanguage.toTranslateLanguage());
  }
  void changeTargetLanguage(Language newTargetLanguage) {
    _targetLanguage = newTargetLanguage;
    _onDeviceTranslator = OnDeviceTranslator(sourceLanguage: _sourceLanguage.toTranslateLanguage(), targetLanguage: _targetLanguage.toTranslateLanguage());
    _onDeviceTranslator2 = OnDeviceTranslator(sourceLanguage: _targetLanguage.toTranslateLanguage(), targetLanguage: _sourceLanguage.toTranslateLanguage());
  }

  Future<Either<Failure,String>> translateByText(String text) async {
    bool isDownloaded = await _onDeviceTranslatorModelManager.isModelDownloaded(_targetLanguage.code);
    print("Model is downloaded ${isDownloaded}");
    if (isDownloaded) {
      print("Dich");
      return Right(await _onDeviceTranslator.translateText(text));
    } else {
      return Left(NotDownloadedYet());
    }
  }

  Future<Either<Failure,String>> translateByTextRevert(String text) async {
    bool isDownloaded = await _onDeviceTranslatorModelManager.isModelDownloaded(_sourceLanguage.code);
    if (isDownloaded) {
      return Right(await _onDeviceTranslator2.translateText(text));
    } else {
      return Left(NotDownloadedYet());
    }
  }

  Future<void> downloadAllModel() async {
    await _onDeviceTranslatorModelManager
        .downloadModel(AppSupportedLanguage.english.code).then((value) => print("====> Downloaded translate english"));
    await _onDeviceTranslatorModelManager
        .downloadModel(AppSupportedLanguage.vietnamese.code).then((value) => print("====> Downloaded translate viet"));
    await _onDeviceTranslatorModelManager
        .downloadModel(AppSupportedLanguage.chinese.code).then((value) => print("====> Downloaded translate china"));
    await _onDeviceTranslatorModelManager
        .downloadModel(AppSupportedLanguage.japanese.code).then((value) => print("====> Downloaded translate japan"));
    await _onDeviceTranslatorModelManager
        .downloadModel(AppSupportedLanguage.spanish.code).then((value) => print("====> Downloaded translate span"));
  }

  Future<void> downloadLanguage() async {
    await _onDeviceTranslatorModelManager.downloadModel(_sourceLanguage.code);
    await _onDeviceTranslatorModelManager.downloadModel(_targetLanguage.code);
  }

  Future<List<Tuple2<String, bool>>> getSupportedLanguage() async {
    List<Tuple2<String, bool>> result = [];
    for (var e in TranslateLanguage.values) {
      result.add(
          Tuple2(
            e.name.capitalizeFirst!,
            await _onDeviceTranslatorModelManager.isModelDownloaded(e.bcpCode),
          )
      );
    }
    return result;
  }
}