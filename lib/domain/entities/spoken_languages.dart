import 'package:equatable/equatable.dart';

class SpokenLanguages extends Equatable {
  final String englishName;
  final String iso6391;
  final String name;

  const SpokenLanguages({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  @override
  List<Object?> get props => [
        englishName,
        iso6391,
        name,
      ];
}
