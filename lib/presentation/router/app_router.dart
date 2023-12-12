import 'package:flutter/material.dart';
import 'package:voice_travel/presentation/screen/conversation/view.dart';
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
              builder: (BuildContext context) => TranslateScreen(initalizedOriginalText: arguments.first, initalizedTranslatedText: arguments.last,)
          );
        }

        return MaterialPageRoute(
            builder: (BuildContext context) => TranslateScreen()
        );
      case voice:
        return MaterialPageRoute(
          builder: (BuildContext context) => const VoiceTranslateScreen()
        );
      case conversation:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ConversationScreen()
        );
      default:
        final arguments = routeSettings.arguments as int;
        return MaterialPageRoute(
          builder: (BuildContext context) => const MyHome(),
        );
    }
  }
}