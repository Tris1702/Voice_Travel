import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';

abstract class EntityExtractionRepository {
  Future<List<EntityAnnotation>> extractEntities(String text);
}