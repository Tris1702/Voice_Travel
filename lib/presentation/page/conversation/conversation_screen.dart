import 'package:flutter/material.dart';
import 'package:voice_travel/data/model/national.dart';
import 'package:voice_travel/presentation/page/conversation/conversation_bloc.dart';
import 'package:voice_travel/presentation/page/conversation/conversation_cell.dart';
import 'package:voice_travel/presentation/page/conversation/micro_component.dart';

class ConversationScreen extends StatelessWidget {
  ConversationScreen({super.key});
  final ConversationBloc bloc = ConversationBloc();
  @override
  Widget build(BuildContext context) {
    bloc.init();
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 3,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            itemBuilder: (context, index) {
              return ConversationCell(
                sourceText: "sourceText",
                targetText: "targetText",
                isLeftSide: index % 2 == 0 ? true : false,
              );
            },
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MicroWidget(
              national: National(name: "English", code: "en"),
              isListening: false,
            ),
            MicroWidget(
              national: National(name: "VietNam", code: "vi"),
              isListening: false,
            ),
          ],
        )
      ],
    );
  }
}
