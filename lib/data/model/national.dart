import 'package:equatable/equatable.dart';

class National extends Equatable {
  final String name;
  final String code;
  final String? subName;

  const National({required this.name, required this.code, this.subName});

  @override
  List<Object?> get props => [name, code];
}
