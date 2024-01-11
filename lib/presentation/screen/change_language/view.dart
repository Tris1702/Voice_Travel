import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voice_travel/presentation/component/text_style.dart';
import 'package:voice_travel/presentation/screen/change_language/bloc.dart';

import '../../../core/constance/app_color.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key, required this.currentLanguage, required this.isSourceLanguage,});

  final String currentLanguage;
  final bool isSourceLanguage;
  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  ChangeLanguageBloc bloc = ChangeLanguageBloc();

  @override
  void initState() {
    super.initState();
    bloc.init();
    bloc.isSourceLanguage = widget.isSourceLanguage;
    bloc.selectedValue = widget.currentLanguage;
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.isSourceLanguage? "Translate from" : "Translate to", style: AppTextStyle.conversationText,),
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

      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
          color: Colors.white
        ),
        child: StreamBuilder(
            stream: bloc.listLanguage.stream,
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final data = snapshot.data as List<Tuple2<String, bool>>;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (_, index) {
                    final item = data.elementAt(index);
                    return ListTile(
                      title: Text(item.value1, style: AppTextStyle.subtitle.copyWith(fontSize: 18),),
                      onTap: () {
                        print("download? ${item.value2}");
                          if (item.value2) {
                            bloc.chooseLanguage(widget.isSourceLanguage, index);
                          } else {
                            popUpDownload(context, index);
                          }
                        },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      dense: false,
                      selected: bloc.selectedValue.toLowerCase() == item.value1.toLowerCase(),
                      trailing: InkWell(
                        child: item.value2
                            ? const Icon(Icons.download_done)
                            : const Icon(Icons.download),
                        onTap: () {
                          if (!item.value2) bloc.downloadLanguage(index);
                        },
                      ),
                    );
                  },
                );
              }
            }
        ),
      ),
    );
  }

  void popUpDownload(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Attention"),
            content: const Text(
              "You need download this language model",
              textAlign: TextAlign.center,
            ),
            actions: [
                TextButton(
                    onPressed: bloc.navigateBack,
                    child: Text("Cancel")
                ),
                TextButton(
                    onPressed: () {
                      bloc.navigateBack();
                      bloc.downloadLanguage(index);
                    },
                    child: Text("Download")
                ),
            ]);
        }
    );
  }
}
