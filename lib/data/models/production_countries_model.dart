import 'package:equatable/equatable.dart';

class ProductionCountriesModel extends Equatable {
  final String iso31661;
  final String name;

  const ProductionCountriesModel({
    required this.iso31661,
    required this.name,
  });

  factory ProductionCountriesModel.fromJson(Map<String, dynamic> json) =>
      ProductionCountriesModel(
        iso31661: json["iso_3166_1"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "iso_3166_1": iso31661,
        "name": name,
      };

  ProductionCountriesModel toEntity() {
    return ProductionCountriesModel(
      iso31661: iso31661,
      name: name,
    );
  }

  @override
  List<Object?> get props => [
        iso31661,
        name,
      ];
}
