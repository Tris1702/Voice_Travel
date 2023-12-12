import 'package:get_it/get_it.dart';
import 'package:google_mlkit_entity_extraction/src/entity_extractor.dart';
import 'package:voice_travel/data/service/google_ml_entity_extraction.dart';

import '../../domain/repository/entity_extraction_repository.dart';

class EntityExtractionRepositoryImpl implements EntityExtractionRepository {
  final repo = GetIt.I<GoogleMLEntityExtraction>();

  @override
  Future<List<EntityAnnotation>> extractEntities(String text) => repo.extractEntities(text);

}