import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/utils.dart';
import 'package:voice_travel/data/model/translate_record.dart';
import 'package:voice_travel/presentation/component/text_style.dart';

import '../../core/constance/app_color.dart';

class ViewTranslateRecord extends StatelessWidget {
  const ViewTranslateRecord({super.key, required this.record});

  final TranslateRecord record;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20,),
        Expanded(child: _cardItem(record.sourceLanguage.name, record.sourceText)),
        const Divider(height: 1, color: AppColor.backgroundIcon2,),
        const SizedBox(height: 10,),
        Expanded(child: _cardItem(record.targetLanguage.name, record.targetText)),
      ],
    );
  }

  Widget _cardItem(String language, String text) {
    return Stack(
      children: [
        Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 50),
              child: Card(
                color: AppColor.onBackground,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    text,
                    style: AppTextStyle.translateWord2,
                  ),
                ),
              ),
            )
        ),
        Positioned(
            top: 0,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: AppColor.backgroundIcon,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Text(
                language.capitalizeFirst!,
                textAlign: TextAlign.right,
                style: AppTextStyle.subtitle
              ),
            )
        ),
        Positioned(
          top: 30,
          right: 10,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: AppColor.backgroundIcon,
                borderRadius: BorderRadius.circular(20)
            ),
            child: InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: text)).then((_) =>
                Fluttertoast.showToast(msg: 'Copied'));
              },
              child: const Icon(Icons.copy),
            )
          )
        )
      ],
    );
  }
}
