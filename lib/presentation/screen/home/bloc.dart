import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:voice_travel/core/bloc_base.dart';
import 'package:voice_travel/presentation/router/app_router.dart';

import '../../../domain/repository/digital_recognition_repository.dart';
import '../../../domain/repository/entity_extraction_repository.dart';
import '../../../domain/repository/translate_repository.dart';

class HomeBloc extends BlocBase {

  BehaviorSubject<String> sourceLanguage = BehaviorSubject();
  BehaviorSubject<String> targetLanguage = BehaviorSubject();

  @override
  void dispose() {
    sourceLanguage.close();
    targetLanguage.close();
  }

  @override
  void init() {
    downloadAllModel();
    sourceLanguage.add('English');
    targetLanguage.add('Vietnamese');
  }

  void downloadAllModel() {
    final translator = GetIt.I<TranslateRepository>();
    final digitalRecognizer = GetIt.I<DigitalRecognitionRepository>();
    final entityExtractor = GetIt.I<EntityExtractionRepository>();

    // EasyLoading.show();
    Future.wait([translator.downloadAllModel(), digitalRecognizer.downloadAllModel(), entityExtractor.downloadAllModel()]).then((value) {
        // print("=====> ALL DONE");
        // EasyLoading.dismiss();
    });

  }

  void navigateToTranslateText() {
    appNavigator.pushed(AppRoute.translateText, argument: ['', '', sourceLanguage.value, targetLanguage.value]);
  }

  void navigateToVoice() {
    appNavigator.pushed(AppRoute.voice,argument: [sourceLanguage.value, targetLanguage.value]);
  }

  void navigateToConversation() {
    appNavigator.pushed(AppRoute.conversation, argument: [sourceLanguage.value, targetLanguage.value]);
  }

  void navigateToLiveTranslate() {
    appNavigator.pushed(AppRoute.camera, argument: [sourceLanguage.value, targetLanguage.value]);
  }

  void navigateToChangeLanguage(bool isSourceLanguage, String language) {
    appNavigator.pushed(AppRoute.changeLanguage, argument: [language, isSourceLanguage]).then((newLanguage) {
      if (newLanguage != null) {
        isSourceLanguage ? sourceLanguage.add(newLanguage) : targetLanguage.add(
            newLanguage);
      }
    }
    );
  }
  
  void navigateToFavourite() {
    appNavigator.pushed(AppRoute.favourite);
  }
}