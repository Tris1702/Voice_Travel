import 'package:flutter/material.dart';
import 'package:voice_travel/presentation/screen/change_language/view.dart';
import 'package:voice_travel/presentation/screen/conversation/view.dart';
import 'package:voice_travel/presentation/screen/favourite_record/view.dart';
import 'package:voice_travel/presentation/screen/history_record/view.dart';
import 'package:voice_travel/presentation/screen/home/view.dart';
import 'package:voice_travel/presentation/screen/translate/view.dart';
import 'package:voice_travel/presentation/screen/voice/view.dart';

import '../screen/live_translate/text_detector_view.dart';

class AppRoute {
  static const String splash = './splash';
  static const String home = './home';
  static const String camera = './camera';
  static const String translateText = '/translateText';
  static const String voice = '/voice';
  static const String conversation = '/conversation';
  static const String changeLanguage = '/changeLanguage';
  static const String favourite = './favourite';
  static const String history = './history';

  static Route<dynamic> getAppPage(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case camera:
        return MaterialPageRoute(
          builder: (BuildContext context) => TextRecognizerView(),
        );
      case translateText:
        final arguments = routeSettings.arguments as List<String>?;
        if (arguments != null) {
          return MaterialPageRoute(
              builder: (BuildContext context) => TranslateScreen(
                initalizedOriginalText: arguments.elementAt(0),
                initalizedTranslatedText: arguments.elementAt(1),
                sourceLanguage: arguments.elementAtOrNull(2),
                targetLanguage: arguments.elementAtOrNull(3),
              ));
        }

        return MaterialPageRoute(
            builder: (BuildContext context) => TranslateScreen()
        );
      case voice:
        final arguments = routeSettings.arguments as List<String>;
        return MaterialPageRoute(
          builder: (BuildContext context) => VoiceTranslateScreen(sourceLanguage: arguments.first, targetLanguage: arguments.last,)
        );
      case conversation:
        final arguments = routeSettings.arguments as List<String>;
        return MaterialPageRoute(
            builder: (BuildContext context) => ConversationScreen(sourceLanguage: arguments.first, targetLanguage: arguments.last,)
        );
      case changeLanguage:
        final arguments = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
            builder: (BuildContext context) => ChangeLanguageScreen(currentLanguage: arguments.first as String, isSourceLanguage: arguments.last as bool, )
        );
      case favourite:
        return MaterialPageRoute(
            builder: (BuildContext context) => const FavouriteScreen());
      case history:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HistoryScreen());
      default:
        return MaterialPageRoute(
          builder: (BuildContext context) => const MyHome(),
        );
    }
  }
}