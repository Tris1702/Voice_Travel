import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voice_travel/data/model/national.dart';
import 'package:voice_travel/presentation/component/box_decoration.dart';
import 'package:voice_travel/presentation/component/text_style.dart';
import 'package:voice_travel/presentation/page/translate_text/translate_text_bloc.dart';

import '../../../data/base/general_state.dart';

class TranslateTextScreen extends StatelessWidget {
  TranslateTextScreen({super.key});

  final TranslateTextBloc bloc = TranslateTextBloc();

  @override
  Widget build(BuildContext context) {
    bloc.init();

    return Container(
      color: Colors.grey.shade100,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: 150,
                decoration: boxDecoration,
                child: StreamBuilder(
                    stream: bloc.sourceNational.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        final data = snapshot.data as National;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data.name,
                              style: AppTextStyle.headerStyle,
                            ),
                            if (data.subName != null)
                              Text(
                                data.subName!,
                                style: AppTextStyle.subtitle,
                              )
                          ],
                        );
                      }
                    }),
              ),
              Container(
                height: 60,
                width: 60,
                color: Colors.white,
                alignment: Alignment.center,
                child: const FaIcon(
                  FontAwesomeIcons.arrowsLeftRight,
                  color: Colors.blue,
                ),
              ),
              Container(
                height: 60,
                width: 150,
                decoration: boxDecoration,
                child: StreamBuilder(
                    stream: bloc.targetNational.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        final data = snapshot.data as National;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data.name,
                              style: AppTextStyle.headerStyle,
                            ),
                            if (data.subName != null)
                              Text(
                                data.subName!,
                                style: AppTextStyle.subtitle,
                              )
                          ],
                        );
                      }
                    }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StreamBuilder(
                        stream: bloc.sourceNational.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            var data = snapshot.data as National;
                            return Text(
                              data.name +
                                  (data.subName != null
                                      ? "(${data.subName})"
                                      : ""),
                              style: AppTextStyle.subtitle,
                            );
                          }
                        },
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {},
                        child: const FaIcon(FontAwesomeIcons.pen, size: 20.0, color: Colors.blue,),
                      ),
                      const SizedBox(width: 10.0,),
                      InkWell(
                        onTap: () {},
                        child: const FaIcon(FontAwesomeIcons.copy, size: 20.0, color: Colors.blue,),
                      ),
                      const SizedBox(width: 10.0,),
                      InkWell(
                        onTap: () {},
                        child: const FaIcon(FontAwesomeIcons.volumeHigh, size: 20.0, color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: TextField(
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      controller: bloc.sourceTextInputController,
                      maxLines: null,
                      minLines: 7,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StreamBuilder(
                        stream: bloc.targetNational.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            var data = snapshot.data as National;
                            return Text(
                              data.name +
                                  (data.subName != null
                                      ? "(${data.subName})"
                                      : ""),
                              style: AppTextStyle.subtitle,
                            );
                          }
                        },
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {},
                        child: const FaIcon(FontAwesomeIcons.copy, size: 20.0, color: Colors.blue,),
                      ),
                      const SizedBox(width: 10.0,),
                      InkWell(
                        onTap: () {},
                        child: const FaIcon(FontAwesomeIcons.volumeHigh, size: 20.0, color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                      child: StreamBuilder(
                    stream: bloc.translateByTextController.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        final data = snapshot.data as TranslateTextState;
                        switch (data) {
                          case TranslateTextState.loading:
                            return const LinearProgressIndicator();
                          case TranslateTextState.success:
                            return Text(
                              data.data!.meaning,
                              style: AppTextStyle.translateWord,
                            );
                          case TranslateTextState.error:
                            return Text(
                              data.error!,
                              style: AppTextStyle.subtitle,
                            );
                          default:
                            return Container();
                        }
                      }
                    },
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
