import 'package:flutter/material.dart';
import 'package:voice_travel/core/setup_service_locator.dart';
import 'package:voice_travel/presentation/page/home_page/home_page_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpServiceLocator();

  runApp(const VoiceTravel());
}

class VoiceTravel extends StatelessWidget {
  const VoiceTravel({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
