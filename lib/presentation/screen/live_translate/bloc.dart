import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:voice_travel/core/bloc_base.dart';
import 'package:voice_travel/domain/repository/translate_repository.dart';
import 'package:voice_travel/presentation/router/app_router.dart';


enum CameraState {
  initialized,
  takePicture,
  displayPicture
}

class CameraBloc extends BlocBase {
  final translator = GetIt.I<TranslateRepository>();

  late CameraDescription camera;
  CameraController? controller;
  String displayImagePath = '';
  late InputImage inputImage;
  late String sourceLanguage;
  late String targetLanguage;

  @override
  void dispose() {
  }

  @override
  void init() {
  }

  CameraBloc() {
    print("===> init camera bloc again");
  }

  Future<String> translateText(String inputString) => translator.translateByWord(inputString).then((value) =>
        value.fold(
                (l) => "",
                (r) => r.toString()));


  Future<RecognizedText> translate(RecognizedText inputString) async {
    String translatedText = "";

    List<TextBlock> resultBlock = [];
    for (var textBlock in inputString.blocks) {
      final newWord = await translateText(textBlock.text);
      translatedText = "$translatedText $newWord";
      resultBlock.add(
          TextBlock(
              text: newWord,
              lines: textBlock.lines,
              boundingBox: textBlock.boundingBox,
              recognizedLanguages: textBlock.recognizedLanguages,
              cornerPoints: textBlock.cornerPoints)
      );
    }
    RecognizedText resultText = RecognizedText(text: translatedText, blocks: resultBlock);
    return resultText;
  }

  Future<List<String>> translateFromImage(RecognizedText inputString) async {
    String originalText = inputString.text;
    String translatedText = await translateText(inputString.text);

    return [originalText, translatedText];
  }

  void showResult(String originalText, String translatedText) async {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    print('=====> translatedText $translatedText');
    appNavigator.pushed(AppRoute.translateText, argument: [originalText, translatedText, sourceLanguage, targetLanguage]).then((_) {
        controller?.resumePreview();
      }
    );
  }

  void popBack() {
    dispose();
    appNavigator.pop();
  }
}