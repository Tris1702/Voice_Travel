import 'package:get_it/get_it.dart';
import 'package:voice_travel/data/repository/translate_repository.dart';
import 'package:voice_travel/data/service/google_ml_service.dart';
import 'package:voice_travel/domain/repository/translate_repository.dart';
import 'package:voice_travel/domain/usecase/translate_by_text.dart';

void setUpServiceLocator() {
  GetIt getIt = GetIt.I;

  // Repo
  getIt.registerLazySingleton<TranslateRepository>(() => TranslateRepositoryImpl());

  // UseCase
  getIt.registerLazySingleton<TranslateByTextUseCase>(() => TranslateByTextUseCase());

  // Service
  getIt.registerLazySingleton<GoogleMLTranslator>(() => GoogleMLTranslator());
}