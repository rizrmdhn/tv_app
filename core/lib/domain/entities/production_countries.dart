import 'package:equatable/equatable.dart';

class ProductionCountries extends Equatable {
  final String iso31661;
  final String name;

  const ProductionCountries({
    required this.iso31661,
    required this.name,
  });

  @override
  List<Object?> get props => [
        iso31661,
        name,
      ];
}
