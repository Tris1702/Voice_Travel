import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voice_travel/core/constance/app_color.dart';
import 'package:voice_travel/data/model/translate_record.dart';
import 'package:voice_travel/presentation/component/text_style.dart';
import 'package:voice_travel/presentation/component/view_translate_record.dart';
import 'package:voice_travel/presentation/screen/favourite_record/bloc.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  FavouriteBloc bloc = FavouriteBloc();

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
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Favourite", style: AppTextStyle.conversationText,),
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
            stream: bloc.translateFavourite.stream,
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final data = snapshot.data as List<TranslateRecord>;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (_, index) {
                    final item = data.elementAt(index);
                    return ListTile(
                      title: Text(item.sourceText, style: AppTextStyle.conversationText, overflow: TextOverflow.fade,),
                      subtitle: Text(item.targetText, style: AppTextStyle.subtitle, overflow: TextOverflow.fade,),
                      trailing: InkWell(
                        onTap: () => bloc.removeRecord(index),
                        child: const FaIcon(FontAwesomeIcons.trashCan),
                      ),
                      onTap: () => _showDetail(context, item),
                    );
                  },
                );
              }
            }
        ),
      ),
    );
  }

  _showDetail(BuildContext context, TranslateRecord item) {
    showModalBottomSheet(context: context, builder: (_) {
      return ViewTranslateRecord(record: item,);
    });
  }
}
