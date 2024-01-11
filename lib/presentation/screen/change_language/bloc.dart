import 'package:dartz/dartz.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/utils.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:voice_travel/core/bloc_base.dart';
import 'package:voice_travel/core/constance/supported_language.dart';
import 'package:voice_travel/data/model/language.dart';
import 'package:voice_travel/domain/repository/digital_recognition_repository.dart';
import 'package:voice_travel/domain/repository/entity_extraction_repository.dart';
import 'package:voice_travel/domain/repository/translate_repository.dart';

class ChangeLanguageBloc extends BlocBase {
  @override
  void dispose() {
    listLanguage.close();
  }

  @override
  void init() {
    _getAllSupportedLanguage();
  }

  BehaviorSubject<List<Tuple2<String, bool>>> listLanguage = BehaviorSubject();
  bool isSourceLanguage = true;
  final translator = GetIt.I<TranslateRepository>();
  final digitalRecognizer = GetIt.I<DigitalRecognitionRepository>();
  final entityExtractor = GetIt.I<EntityExtractionRepository>();

  String selectedValue = "";

  void _getAllSupportedLanguage() async {
    List<Tuple2<String, bool>> result = [];
    result.add(
        Tuple2(
          AppSupportedLanguage.english.name.capitalizeFirst!,
          true,
        )
    );
    result.add(
        Tuple2(
          AppSupportedLanguage.vietnamese.name.capitalizeFirst!,
          true,
        )
    );
    result.add(
        Tuple2(
          AppSupportedLanguage.spanish.name.capitalizeFirst!,
          true,
        )
    );
    result.add(
        Tuple2(
          AppSupportedLanguage.chinese.name.capitalizeFirst!,
          true,
        )
    );
    result.add(
        Tuple2(
          AppSupportedLanguage.japanese.name.capitalizeFirst!,
          true,
        )
    );
    listLanguage.add(result);
  }

  void downloadLanguage(int index) {
    Fluttertoast.showToast(msg: "Downloading models...");
    EasyLoading.show();
    Future.wait([translator.downloadLanguage(), digitalRecognizer.downloadModel(), entityExtractor.downloadModel()]).then((value) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Model downloaded...");
      _getAllSupportedLanguage();
    });
  }

  void navigateBack() {
    appNavigator.pop(result: selectedValue);
  }

  void chooseLanguage(bool isSourceLanguage, int index) {
    print(listLanguage.value.elementAt(index).value1);
    final newLanguage = Language.fromName(listLanguage.value.elementAt(index).value1);
    if (isSourceLanguage) {
      translator.changeSourceLanguage(newLanguage);
      digitalRecognizer.changeSourceLanguage(newLanguage);
      entityExtractor.changeSourceLanguage(newLanguage);
    } else {
      translator.changeTargetLanguage(newLanguage);
    }
    selectedValue = newLanguage.name.capitalizeFirst!;
    navigateBack();
  }
}
