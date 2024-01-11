import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:voice_travel/presentation/component/text_style.dart';
import 'package:voice_travel/presentation/screen/conversation/bloc.dart';

import '../../../core/constance/app_color.dart';
import '../../../data/model/language.dart';

class MicroWidget extends StatelessWidget {
  const MicroWidget(
      {super.key,
      required this.language,
      required this.bloc,
      required this.isLeft});
  final Language language;
  final ConversationBloc bloc;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(language.name.capitalizeFirst!, style: AppTextStyle.headerStyle.copyWith(color: AppColor.backgroundIcon2, fontWeight: FontWeight.bold),),
        const SizedBox(height: 8,),
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.backgroundIcon,
          ),
          padding: const EdgeInsets.all(30),
          child: isLeft
              ? StreamBuilder(
                stream: bloc.isListeningLeft.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  final data = snapshot.data as bool;
                  return InkWell(
                        onTap: () {
                          if (!data) {
                            bloc.startListening(isLeft);
                          } else {
                            bloc.stopListeningOnly(isLeft);
                          }
                        },
                        child: !data
                            ? const Icon(
                          Icons.mic_none,
                          color: Colors.black87,
                          size: 40,
                        )
                            : const Icon(
                          Icons.stop_outlined,
                          color: Colors.black87,
                          size: 40,
                        )
                      );
                })
              : StreamBuilder(
                stream: bloc.isListeningRight.stream,
                builder: (context, snapshot) {
                  print("===> new value");
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  final data = snapshot.data as bool;
                  return InkWell(
                    onTap: () {
                      if (!data) {
                        bloc.startListening(isLeft);
                      } else {
                        bloc.stopListeningOnly(isLeft);
                      }
                    },
                    child: !data
                        ? const Icon(
                          Icons.mic_none,
                          color: Colors.black87,
                          size: 40,
                        )
                        : const Icon(
                          Icons.stop_outlined,
                          color: Colors.black87,
                          size: 40,
                        )
                  );
                }
              ),
        ),
        const SizedBox(height: 20,)
      ],
    );
  }
}
