import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voice_travel/core/constance/app_color.dart';
import 'package:voice_travel/core/constance/app_string.dart';
import 'package:voice_travel/presentation/component/text_style.dart';
import 'package:voice_travel/presentation/screen/home/bloc.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  HomeBloc bloc = HomeBloc();

  @override
  void initState() {
    super.initState();
    bloc.init();
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
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: const Text(AppString.appName, style: TextStyle(color: AppColor.text),),
        backgroundColor: AppColor.onBackground,
        elevation: 0,
        centerTitle: true,
        leading: Center(
          child: InkWell(
            onTap: () {},
            child: const FaIcon(FontAwesomeIcons.solidStar, color: Colors.black87,),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: bloc.navigateToTranslateText,
              child: const Card(
                color: AppColor.onBackground,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 100,
                      left: 20,
                      right: 20,
                  ),
                  child: Text("Enter text", style: AppTextStyle.translateWord,),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Column(
            children: [
              _switchLanguage(),
              const SizedBox(height: 15,),
              _utilitiesWidget(),
              const SizedBox(height: 15,),
            ],
          ),
        ],
      ),
    );
  }

  Widget _switchLanguage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 50,
          width: 150,
          child: const Center(
            child: Text(
              'English', style: AppTextStyle.subtitle,
            ),
          ),
        ),
        InkWell(
            onTap: () {},
            child: const Icon(Icons.sync_alt_outlined),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 50,
          width: 150,
          child: const Center(
            child: Text(
              'Vietnamese', style: AppTextStyle.subtitle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _utilitiesWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.backgroundIcon,
              ),
              padding: const EdgeInsets.all(15),
              child: InkWell(
                onTap: bloc.navigateToConversation,
                child: const Icon(Icons.people_alt_outlined),
              ),
            ),
            const SizedBox(height: 5,),
            const Text("Conversation"),
          ],
        ),
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.backgroundIcon2,
          ),
          padding: const EdgeInsets.all(30),
          child: InkWell(
            onTap: bloc.navigateToVoice,
            child: const Icon(Icons.mic_none, color: Colors.white, size: 40,),
          ),
        ),
        Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.backgroundIcon,
              ),
              padding: const EdgeInsets.all(15),
              child: InkWell(
                onTap: bloc.navigateToLiveTranslate,
                child: const FaIcon(FontAwesomeIcons.cameraRetro),
              ),
            ),
            const SizedBox(height: 5,),
            const Text("Camera"),
          ],
        )
      ],
    );
  }
}
