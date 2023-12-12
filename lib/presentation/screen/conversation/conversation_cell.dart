import 'package:flutter/material.dart';
import 'package:voice_travel/presentation/component/text_style.dart';

import '../../../core/constance/app_color.dart';

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
      crossAxisAlignment: isLeftSide ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Padding(
          padding: isLeftSide ? const EdgeInsets.only(right: 30) : const EdgeInsets.only(left: 30),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: isLeftSide ? AppColor.backgroundIcon : AppColor.backgroundIcon2,
              borderRadius: BorderRadius.circular(20)
            ),
            padding: const EdgeInsets.all(20),
            child:
              sourceText == "..."
            ? Column(
                crossAxisAlignment:
                isLeftSide ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  CircularProgressIndicator(color: isLeftSide ? Colors.black87 : Colors.white,),
                ],
            )
            : Column(
              crossAxisAlignment:
                  isLeftSide ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(
                  sourceText,
                  style: AppTextStyle.subtitle.copyWith(color: isLeftSide ? Colors.black87 : Colors.white,),
                ),
                const SizedBox(height: 10),
                Text(
                  targetText,
                  style: AppTextStyle.conversationText.copyWith(color: isLeftSide ? Colors.black87 : Colors.white,)
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 10,)
      ],
    );
  }
}
