import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/utils.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_travel/presentation/screen/voice/bloc.dart';

import '../../../core/constance/app_color.dart';
import '../../component/text_style.dart';

class VoiceTranslateScreen extends StatefulWidget {
  const VoiceTranslateScreen({super.key, required this.sourceLanguage, required this.targetLanguage});

  final String sourceLanguage;
  final String targetLanguage;

  @override
  State<VoiceTranslateScreen> createState() => _VoiceTranslateScreenState();
}

class _VoiceTranslateScreenState extends State<VoiceTranslateScreen> {
  VoiceBloc bloc = VoiceBloc();

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
  void dispose() {
    bloc.dispose();
    super.dispose();
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
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.sourceLanguage.capitalizeFirst!,
                          style: AppTextStyle.subtitle,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: bloc.copyInputText,
                          child: const Icon(
                            Icons.copy,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: bloc.readInputText,
                          child: const Icon(
                            Icons.volume_up_outlined,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    TextField(
                      controller: bloc.inputTextController,
                      style: AppTextStyle.translateWord2,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      onEditingComplete: bloc.extractEntity,
                      enabled: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Divider(
                          color: AppColor.backgroundIcon2,
                          thickness: 1.5,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.targetLanguage.capitalizeFirst!,
                          style: AppTextStyle.subtitle.copyWith(
                              color: AppColor.backgroundIcon2),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: bloc.copyOutputText,
                          child: const Icon(
                            Icons.copy,
                            color: AppColor.backgroundIcon2,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: bloc.readOutputText,
                          child: const Icon(
                            Icons.volume_up_outlined,
                            color: AppColor.backgroundIcon2,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    TextField(
                      controller: bloc.outputTextController,
                      style: AppTextStyle.translateWord3,
                      enabled: false,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          StreamBuilder(
              stream: bloc.isListening.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final isListening = snapshot.data!;
                  return AvatarGlow(
                      animate: isListening,
                      endRadius: 70,
                      glowColor: AppColor.backgroundIcon2,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.backgroundIcon2,
                        ),
                        padding: const EdgeInsets.all(30),
                        child: InkWell(
                          onTap: () => !isListening
                              ? bloc.startListening()
                              : bloc.stopListening(),
                          child: !isListening
                              ? const Icon(Icons.mic_none, color: Colors.white, size: 40,)
                              : const Icon(Icons.stop, color: Colors.white, size: 40,)
                        ),
                      )
                  );
                } else {
                  return Container();
                }
              }
          )
        ],
      ),
    );
  }
}
