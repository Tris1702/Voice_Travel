import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voice_travel/presentation/component/text_style.dart';

import '../../../core/constance/app_color.dart';
import '../../component/extracted_entity_cell.dart';
import '../../component/pain_liner.dart';
import 'bloc.dart';

class TranslateScreen extends StatefulWidget {
  TranslateScreen({
    super.key,
    this.initalizedOriginalText = '',
    this.initalizedTranslatedText = '',
  });

  String initalizedOriginalText;
  String initalizedTranslatedText;


  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  TranslateBloc bloc = TranslateBloc();

  @override
  void initState() {
    super.initState();
    bloc.init();
    bloc.inputTextController.text = widget.initalizedOriginalText;
    bloc.outputTextController.text = widget.initalizedTranslatedText;
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
        actions: [
          InkWell(
            onTap: () => _showExtractedEntities(context),
            child: const Icon(Icons.lightbulb_outline , color: Colors.black87)
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () => bloc.changeWritingState(true),
            child: const Icon(Icons.draw_outlined, color: Colors.black87),
          ),
          const SizedBox(
            width: 10,
          ),
          KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
            if (isKeyboardVisible) {
              bloc.changeWritingState(false);
              if (bloc.inputTextController.text.isEmpty) {
                return InkWell(
                  onTap: () {},
                  child: const Icon(Icons.history, color: Colors.black87),
                );
              } else {
                return InkWell(
                  onTap: bloc.inputTextController.clear,
                  child: const Icon(Icons.close, color: Colors.black87),
                );
              }
            } else {
              return InkWell(
                onTap: () {},
                child: const Icon(Icons.star_border, color: Colors.black87),
              );
            }
          }),
          const SizedBox(
            width: 20,
          ),
        ],
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      KeyboardVisibilityBuilder(
                        builder: (context, isKeyboardVisible) => isKeyboardVisible
                            ? const SizedBox(
                                height: 0,
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "English",
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
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.3,
                        child: TextField(
                          controller: bloc.inputTextController,
                          style: AppTextStyle.translateWord2,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter text',
                          ),
                          onChanged: (_) => bloc.translate(),
                        ),
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
                      KeyboardVisibilityBuilder(
                        builder: (context, isKeyboardVisible) => isKeyboardVisible
                            ? const SizedBox(
                                height: 0,
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Vietnamese",
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
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.3,
                        child: TextField(
                          controller: bloc.outputTextController,
                          style: AppTextStyle.translateWord3,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
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
          ),
          const SizedBox(
            height: 10,
          ),
          _switchLanguage(),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder(
            stream: bloc.isWriting.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return _inkText();
              } else {
                return Container();
              }
            }
          )
        ],
      ),
    );
  }

  void _showExtractedEntities(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (contextBottomSheet) {
          return StreamBuilder(
            stream: bloc.extractedEntities.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) return Container();
              final entities = snapshot.data!;
              if (entities.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mood_bad_outlined, size: 150, color: Colors.grey,),
                      SizedBox(height: 10),
                      Text("Oops no suggestion!", style: TextStyle(fontSize: 50, color: Colors.grey,), textAlign: TextAlign.center,)
                    ],
                  ),
                );
              }
              else {
                return ListView.builder(
                  itemCount: entities.length,
                  itemBuilder: (_, index) => ExtractedEntityCell(
                    entity: entities.elementAt(index)
                  )
              );
              }
            }
          );
        }
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
              'English',
              style: AppTextStyle.subtitle,
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
              'Vietnamese',
              style: AppTextStyle.subtitle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _inkText() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: double.infinity,
          child: Container(
            color: AppColor.backgroundIcon,
            child: StreamBuilder(
              stream: bloc.recognizedText.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final recognizedText = snapshot.data!;
                  return ListView.builder(
                    itemCount: recognizedText.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: GestureDetector(
                          onTap: () => bloc.addWord(recognizedText.elementAt(index)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Text(recognizedText.elementAt(index), style: AppTextStyle.subtitle,),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            )
          ),
        ),
        SizedBox(
          height: 250,
          width: double.infinity,
          child: StreamBuilder(
              stream: bloc.sequencePoints.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                final sequencePoints = snapshot.data!;
                return CustomPaint(
                    painter: BlackLinePainter(sequencePoints),
                    child: Listener(
                      behavior: HitTestBehavior.opaque,
                      onPointerMove: (event) => bloc.updateSequencePoints(event.localPosition),
                      onPointerDown: (_) =>
                          bloc.sequencePoints.value.add(List.empty(growable: true)),
                      onPointerUp: (_) => bloc.recognitionText(),
                    ));
              }),
        ),
        Row(
          children: [
            const SizedBox(width: 5,),
            OutlinedButton(
              onPressed: bloc.undo,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(color: Colors.black87),
              ),
              child: const Icon(Icons.undo, color: AppColor.backgroundIcon2,),
            ),
            const SizedBox(width: 5,),
            Expanded(
              child: OutlinedButton(
                onPressed: bloc.addSpace,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: const BorderSide(color: Colors.black87),
                ),
                child: const Icon(Icons.space_bar, color: AppColor.backgroundIcon2,),
              ),
            ),
            const SizedBox(width: 5,),
            OutlinedButton(
              onPressed: bloc.deleteLastText,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(color: Colors.black87),
              ),
              child: const Icon(Icons.backspace_outlined, color: AppColor.backgroundIcon2,),
            ),
            const SizedBox(width: 5,),
            OutlinedButton(
              onPressed: () => bloc.changeWritingState(false),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.backgroundIcon2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Icon(Icons.arrow_forward, color: Colors.white,),
            ),
            const SizedBox(width: 5,),
          ],
        )
      ],
    );
  }
}
