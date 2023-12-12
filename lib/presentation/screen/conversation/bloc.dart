import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_travel/core/bloc_base.dart';

import '../../../domain/repository/translate_repository.dart';

class ConversationBloc extends BlocBase {
  BehaviorSubject<List<Tuple3<String, String, bool>>> conversation = BehaviorSubject<List<Tuple3<String,String, bool>>>.seeded(List.empty(growable: true));
  final BehaviorSubject<bool> isListeningLeft = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> isListeningRight = BehaviorSubject.seeded(false);
  final ScrollController conversationController = ScrollController();
  final translator = GetIt.I<TranslateRepository>();
  SpeechToText speech = SpeechToText();
  bool isAvailable = false;
  String words = '';

  @override
  void dispose() {
    conversation.close();
    isListeningRight.close();
    isListeningLeft.close();
    speech.stop();
    speech.cancel();
  }

  @override
  void init() {
    print("====> start init");
    speech.initialize().then((value) {
      isAvailable = value;
      print("====> ok isAvailable: $isAvailable");
    } );
  }

  void stopListening(bool isLeft) async {
    if (conversation.value.isEmpty) return;
    conversation.value.removeLast();
    if (words.isNotEmpty) {
      if (isLeft) {conversation.value.add(Tuple3(words, await translateWord(words, isLeft), isLeft));}
      else {conversation.value.add(Tuple3(words, await translateByTextRevert(words, isLeft), isLeft));}
      conversation.sink.add(conversation.value);
      words = "";
      Future.delayed(const Duration(milliseconds: 500)).then((_) => scrollDown());
      await speech.stop();
      return;
    }
    conversation.sink.add(conversation.value);
    scrollDown();

    await speech.stop();
    print("====> stop");
  }

  void stopListeningOnly(bool isLeft) async {
    print("===> stop only");
    if (speech.isListening) {
      stopListening(isLeft);
    }

    _changeListening(isLeft);
  }

  void addThreeDot(bool isLeft) async {
    if (isLeft) {conversation.value.add(Tuple3("...", await translateWord(words, isLeft), isLeft));}
    else {conversation.value.add(Tuple3("...", await translateByTextRevert(words, isLeft), isLeft));}
    conversation.sink.add(conversation.value);
    Future.delayed(const Duration(milliseconds: 500)).then((_) => scrollDown());
  }

  void startListening(bool isLeft) {
    if (!isAvailable) return;
    if (speech.isListening) return;

    addThreeDot(isLeft);

    if (isLeft) {
      speech.listen(
          onResult: (result) => _onSpeechResult(result, isLeft),
          localeId: "en_EN",
          listenFor: const Duration(seconds: 10)
      ).then((value) => _changeListening(isLeft));
    } else {
      speech.listen(
          onResult: (result) => _onSpeechResult(result, isLeft),
          localeId: "vi_VN",
          listenFor: const Duration(seconds: 10)
      ).then((value) => _changeListening(isLeft));
    }
  }

  void _changeListening(bool isLeft) {
    print('===> change listen');
    isLeft
        ? isListeningLeft.sink.add(speech.isListening)
        : isListeningRight.sink.add(speech.isListening);
  }

  void _onSpeechResult(SpeechRecognitionResult result, bool isLeft) {
    print("==> on result");
    words = result.recognizedWords;
    final deviceListening = isListeningLeft.value || isListeningRight.value;
    print("===> $words | ${speech.isListening} | ${deviceListening}");
    if (speech.isNotListening && deviceListening) {
      _changeListening(isLeft);
      stopListening(isLeft);
    }
  }

  Future<String> translateWord(String text, bool isLeft) async {
    return await translator.translateByWord(text).then((value) {
      return value.fold(
              (l) => '',
              (r) => r.toString());

    });
  }

  Future<String> translateByTextRevert(String text, bool isLeft) async {
    return await translator.translateByTextRevert(text).then((value) {
      return value.fold(
              (l) => '',
              (r) => r.toString());
    });
  }

  void navigateBack() {
    appNavigator.pop();
  }

  void scrollDown() {
    conversationController.animateTo(
      conversationController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }
}