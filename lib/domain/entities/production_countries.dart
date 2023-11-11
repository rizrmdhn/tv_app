import 'package:equatable/equatable.dart';

class ProductionCountries extends Equatable {
  final String iso31661;
  final String name;

  const ProductionCountries({
    required this.iso31661,
    required this.name,
  });

  factory ProductionCountries.fromJson(Map<String, dynamic> json) =>
      ProductionCountries(
        iso31661: json["iso_3166_1"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "iso_3166_1": iso31661,
        "name": name,
      };

  @override
  List<Object?> get props => [
        iso31661,
        name,
      ];
}
