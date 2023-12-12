import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_travel/presentation/screen/conversation/bloc.dart';

import '../../../core/constance/app_color.dart';
import '../../../data/model/national.dart';
import 'conversation_cell.dart';
import 'micro_component.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ConversationBloc bloc = ConversationBloc();

  void _requestPermission() async {
    final status = await Permission.microphone.status;
    if (status.isDenied) {
      Permission.microphone.request();
    } else if (status.isGranted) {
      bloc.init();
    }
  }

  @override
  void initState() {
    Permission.microphone.onGrantedCallback(() => bloc.init());
    super.initState();
    _requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.onBackground,
        elevation: 0,
        centerTitle: true,
        leading: Center(
          child: InkWell(
            onTap: bloc.navigateBack,
            child: const FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.black87,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Card(
            color: AppColor.onBackground,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 100,
                  left: 20,
                  right: 20,
                ),
                child: StreamBuilder(
                    stream: bloc.conversation.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      final data = snapshot.data!;
                      return ListView.builder(
                        itemCount: data.length,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        controller: bloc.conversationController,
                        itemBuilder: (context, index) {
                          Tuple3<String, String,bool> item = data.elementAt(index);
                          return ConversationCell(
                            sourceText: item.value1,
                            targetText: item.value2,
                            isLeftSide: item.value3,
                          );
                        },
                      );
                    }
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MicroWidget(
                national: const National(name: "English", code: "en"),
                bloc: bloc,
                isLeft: true,
              ),
              MicroWidget(
                national: const National(name: "VietNam", code: "vi"),
                bloc: bloc,
                isLeft: false,
              ),
            ],
          )
        ],
      ),
    );
  }
}

