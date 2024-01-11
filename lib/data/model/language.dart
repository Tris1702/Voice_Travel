import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:voice_travel/core/constance/supported_language.dart';

class Language extends Equatable {
  final String code;
  final String name;

  factory Language.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return Language(code: json['code'] as String, name: json['name'] as String);
  }

  Map toJson() => {
    'code': code,
    'name': name,
  };

  String toJsonString() => jsonEncode(this);

  const Language({required this.code, required this.name});

  static Language fromCode(String code) {
    if (AppSupportedLanguage.vietnamese.code == code) return AppSupportedLanguage.vietnamese;
    if (AppSupportedLanguage.spanish.code == code) return AppSupportedLanguage.spanish;
    if (AppSupportedLanguage.japanese.code == code) return AppSupportedLanguage.japanese;
    if (AppSupportedLanguage.chinese.code == code) return AppSupportedLanguage.chinese;
    return AppSupportedLanguage.english;
  }

  static Language fromName(String name) {
    if (AppSupportedLanguage.vietnamese.name.toLowerCase() == name.toLowerCase()) return AppSupportedLanguage.vietnamese;
    if (AppSupportedLanguage.spanish.name.toLowerCase() == name.toLowerCase()) return AppSupportedLanguage.spanish;
    if (AppSupportedLanguage.japanese.name.toLowerCase() == name.toLowerCase()) return AppSupportedLanguage.japanese;
    if (AppSupportedLanguage.chinese.name.toLowerCase() == name.toLowerCase()) return AppSupportedLanguage.chinese;
    return AppSupportedLanguage.english;
  }

  EntityExtractorLanguage toEntityExtractorLanguage() {
    final entityLanguage = EntityExtractorLanguage.values.firstWhere((element) => element.name.toLowerCase() == name.toLowerCase());
    return entityLanguage;
  }

  TranslateLanguage toTranslateLanguage() {
    final translateLanguage = TranslateLanguage.values.firstWhere((element) => element.name.toLowerCase() == name.toLowerCase());
    return translateLanguage;
  }

  TextRecognitionScript toTextRecognitionScript() {
    if (this == AppSupportedLanguage.chinese) return TextRecognitionScript.chinese;
    if (this == AppSupportedLanguage.japanese) return TextRecognitionScript.japanese;
    return TextRecognitionScript.latin;
  }

  @override
  List<Object?> get props => [name, code];
}
