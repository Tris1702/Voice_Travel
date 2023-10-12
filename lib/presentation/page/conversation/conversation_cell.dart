import 'package:flutter/material.dart';
import 'package:voice_travel/presentation/component/text_style.dart';

class ConversationCell extends StatelessWidget {
  final String sourceText;
  final String targetText;
  final bool isLeftSide;

  const ConversationCell({
    super.key,
    required this.sourceText,
    required this.targetText,
    required this.isLeftSide,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isLeftSide ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          sourceText,
          style: AppTextStyle.subtitle,
        ),
        Text(
          targetText,
          style: AppTextStyle.conversationText,
        )
      ],
    );
  }
}
