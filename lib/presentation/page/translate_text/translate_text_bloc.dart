import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:voice_travel/data/model/national.dart';
import 'package:voice_travel/presentation/component/bloc_base.dart';

import '../../../data/base/general_state.dart';

class TranslateTextBloc implements BlocBase {
  var translateByTextController = BehaviorSubject<TranslateTextState>();
  var sourceNational = BehaviorSubject<National>();
  var targetNational = BehaviorSubject<National>();
  var sourceTextInputController = TextEditingController();

  @override
  void dispose() {
    translateByTextController.close();
    sourceNational.close();
    targetNational.close();
  }

  @override
  void init() {
    translateByTextController.sink.add(TranslateTextState.initialize());
    sourceNational.sink.add(const National(name: "English", code: "eng", subName: "US"));
    targetNational.sink.add(const National(name: "Viet Nam", code: "vi", subName: null));
  }
}
