import 'package:get_it/get_it.dart';
import 'package:voice_travel/data/repository/digital_recognition_repository.dart';
import 'package:voice_travel/data/repository/translate_repository.dart';
import 'package:voice_travel/data/service/google_ml_service.dart';
import 'package:voice_travel/domain/repository/translate_repository.dart';
import 'package:voice_travel/domain/usecase/translate_by_text.dart';
import 'package:voice_travel/presentation/screen/live_translate/bloc.dart';

import '../data/repository/entity_extraction_repository.dart';
import '../domain/repository/digital_recognition_repository.dart';
import '../domain/repository/entity_extraction_repository.dart';
import '../presentation/router/navigator_service.dart';

void setUpServiceLocator() {
  GetIt getIt = GetIt.I;

  // navigator
  getIt.registerLazySingleton<NavigatorService>(() => NavigatorService());

  // Repo
  getIt.registerLazySingleton<TranslateRepository>(() => TranslateRepositoryImpl());
  getIt.registerLazySingleton<DigitalRecognitionRepository>(() => DigitalRecognitionRepositoryImpl());
  getIt.registerLazySingleton<EntityExtractionRepository>(() => EntityExtractionRepositoryImpl());

  // UseCase
  getIt.registerLazySingleton<TranslateByTextUseCase>(() => TranslateByTextUseCase());

  // Service
  getIt.registerSingleton<GoogleMLTranslator>(GoogleMLTranslator());
  getIt.registerSingleton<GoogleMLDigitalRecognition>(GoogleMLDigitalRecognition());
  getIt.registerSingleton<GoogleMLEntityExtraction>(GoogleMLEntityExtraction());

  // Bloc
  getIt.registerLazySingleton<CameraBloc>(() => CameraBloc());
}