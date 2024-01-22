import 'package:equatable/equatable.dart';
import 'package:voice_travel/data/model/language.dart';

class TranslateRecord extends Equatable {
  final Language sourceLanguage;
  final Language targetLanguage;
  final String sourceText;
  final String targetText;

  const TranslateRecord({
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.sourceText,
    required this.targetText,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [sourceLanguage, targetLanguage, sourceText, targetText];
}
