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

  factory SpokenLanguages.fromJson(Map<String, dynamic> json) =>
      SpokenLanguages(
        englishName: json["english_name"],
        iso6391: json["iso_639_1"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "english_name": englishName,
        "iso_639_1": iso6391,
        "name": name,
      };

  @override
  List<Object?> get props => [
        englishName,
        iso6391,
        name,
      ];
}
