import 'package:equatable/equatable.dart';

class Word extends Equatable {
  final String meaning;
  final String national;

  const Word({
    required this.meaning,
    required this.national,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [meaning, national];
}
