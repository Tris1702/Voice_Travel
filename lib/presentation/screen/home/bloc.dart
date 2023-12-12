import 'package:get_it/get_it.dart';
import 'package:voice_travel/core/bloc_base.dart';
import 'package:voice_travel/presentation/router/app_router.dart';

class HomeBloc extends BlocBase {



  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void init() {
  }

  void navigateToTranslateText() {
    appNavigator.pushed(AppRoute.translateText);
  }

  void navigateToVoice() {
    appNavigator.pushed(AppRoute.voice);
  }

  void navigateToConversation() {
    appNavigator.pushed(AppRoute.conversation);
  }

  void navigateToLiveTranslate() {
    appNavigator.pushed(AppRoute.camera);
  }
}