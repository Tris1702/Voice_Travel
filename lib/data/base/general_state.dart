import '../model/word.dart';

enum GeneralStateType {
  initialize,
  loading,
  success,
  error,
}

class GeneralState<T, E> {
  final GeneralStateType state;
  final T? data;
  final E? error;

  const GeneralState(this.state, {this.data, this.error});

  factory GeneralState.initialize() {
    return const GeneralState(GeneralStateType.initialize);
  }

  factory GeneralState.loading() {
    return const GeneralState(GeneralStateType.loading);
  }

  factory GeneralState.success(T data) {
    return GeneralState(GeneralStateType.success, data: data);
  }

  factory GeneralState.error(E error) {
    return GeneralState(GeneralStateType.error, error: error);
  }
}

typedef TranslateTextState = GeneralState<Word, String>;