import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';
import 'package:voice_travel/core/constance/supported_language.dart';
import 'package:voice_travel/data/model/language.dart';

class GoogleMLEntityExtraction {
  final _modelManager = EntityExtractorModelManager();
  late Language _sourceLanguage;
  late EntityExtractor _entityExtractor;

  GoogleMLEntityExtraction() {
    changeModel(AppSupportedLanguage.english);
  }
  Future<void> downloadAllModel() async {
    await _modelManager
        .downloadModel(AppSupportedLanguage.english.code).then((value) => print("====> Downloaded entity english"));
    await _modelManager
        .downloadModel(AppSupportedLanguage.chinese.code).then((value) => print("====> Downloaded entity china"));
    await _modelManager
        .downloadModel(AppSupportedLanguage.japanese.code).then((value) => print("====> Downloaded entity japan"));
    await _modelManager
        .downloadModel(AppSupportedLanguage.spanish.code).then((value) => print("====> Downloaded entity spanish"));
  }

  changeModel(Language newLanguage) {
    if (newLanguage == AppSupportedLanguage.vietnamese) return;
    print("===> Entity change to ${newLanguage.name}");
    _sourceLanguage = newLanguage;
    _entityExtractor = EntityExtractor(language: _sourceLanguage.toEntityExtractorLanguage());
  }

  Future<bool> downloadModel() async {
    if (_sourceLanguage == AppSupportedLanguage.vietnamese) return true;
    final isDownloaded = await _isModelDownloaded();
    if (!isDownloaded) {
      return await _modelManager.downloadModel(_sourceLanguage.code);
    }
    return true;
  }

  Future<bool> _isModelDownloaded() async {
    return await _modelManager.isModelDownloaded(_sourceLanguage.code);
  }

  Future<List<EntityAnnotation>> extractEntities(String text) async {
    return await _entityExtractor.annotateText(text);
  }
}