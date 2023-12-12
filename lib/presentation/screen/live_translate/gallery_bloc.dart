import 'package:get_it/get_it.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:voice_travel/core/bloc_base.dart';

import '../../../domain/repository/translate_repository.dart';
import '../../router/app_router.dart';

class GalleryBloc extends BlocBase {

  final translator = GetIt.I<TranslateRepository>();
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<List<String>> translateImageFromGallery(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    String translatedText = '';
    await translator.translateByWord(text).then((value) =>
        value.fold(
                (l) => null,
                (r) => translatedText = r.toString())
    );
    return [text, translatedText];
  }

  void openCamera() {
    appNavigator.pushed(AppRoute.camera);
  }

  @override
  void dispose() {
    textRecognizer.close();
  }

  @override
  void init() {
  }
}