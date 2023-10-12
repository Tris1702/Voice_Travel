import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/model/national.dart';

class MicroWidget extends StatelessWidget {
  const MicroWidget({super.key, required this.national, required this.isListening});
  final National national;
  final bool isListening;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(national.name),
        AvatarGlow(
          animate: isListening,
          glowColor: Colors.blue,
          endRadius: 50.0,
          repeat: true,
          showTwoGlows: true,
          child: FaIcon(
            FontAwesomeIcons.microphone,
            color: isListening ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }
}
