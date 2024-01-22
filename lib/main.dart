import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:voice_travel/core/setup_service_locator.dart';
import 'package:voice_travel/presentation/router/app_router.dart';
import 'package:voice_travel/presentation/router/navigator_service.dart';
import 'package:voice_travel/presentation/screen/home/view.dart';

import 'data/service/database_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpServiceLocator();
  GetIt.I<DatabaseService>().getDB();
  runApp(const VoiceTravel());
}

class VoiceTravel extends StatelessWidget {
  const VoiceTravel({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        home: const MyHome(),
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        navigatorKey: GetIt.I<NavigatorService>().navigatorKey,
        onGenerateRoute: (RouteSettings routeSettings) =>
            AppRoute.getAppPage(routeSettings),
      ),
    );
  }
}
