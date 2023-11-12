import 'package:equatable/equatable.dart';

class Crew extends Equatable {
  final String? job;
  final String? department;
  final String? creditId;
  final bool? adult;
  final int? gender;
  final int id;
  final String? knownForDepartment;
  final String? name;
  final String? originalName;
  final double? popularity;
  final String? profilePath;

  const Crew({
    required this.job,
    required this.department,
    required this.creditId,
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
  });

  @override
  List<Object?> get props => [
        job,
        department,
        creditId,
        adult,
        gender,
        id,
        knownForDepartment,
        name,
        originalName,
        popularity,
        profilePath,
      ];
}
