import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';

class GoogleMLEntityExtraction {
  final _modelManager = EntityExtractorModelManager();
  final _language = EntityExtractorLanguage.english;
  final _entityExtractor = EntityExtractor(language: EntityExtractorLanguage.english);

  GoogleMLEntityExtraction() {
    _isModelDownloaded().then((value) {
      if(!value) _downloadModel();
    });
  }

  Future<void> _downloadModel() async {
    Fluttertoast.showToast(msg: 'Downloading model...');

    _modelManager.downloadModel(_language.name)
            .then((value) => value ? 'success' : 'failed');
  }

  Future<bool> _isModelDownloaded() async {
    return await _modelManager.isModelDownloaded(_language.name);
  }

  Future<List<EntityAnnotation>> extractEntities(String text) async {
    return await _entityExtractor.annotateText(text);
  }
}