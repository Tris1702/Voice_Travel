import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';
import 'package:voice_travel/data/model/language.dart';

abstract class EntityExtractionRepository {
  Future<List<EntityAnnotation>> extractEntities(String text);
  Future<void> downloadAllModel();
  Future<bool> downloadModel();
  void changeSourceLanguage(Language newLanguage);
}