import 'package:core/domain/entities/crew.dart';
import 'package:equatable/equatable.dart';

class CrewModel extends Equatable {
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

  const CrewModel({
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

  factory CrewModel.fromJson(Map<String, dynamic> json) => CrewModel(
        job: json["job"],
        department: json["department"],
        creditId: json["credit_id"],
        adult: json["adult"],
        gender: json["gender"],
        id: json["id"],
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        originalName: json["original_name"],
        popularity: json["popularity"]?.toDouble(),
        profilePath: json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "job": job,
        "department": department,
        "credit_id": creditId,
        "adult": adult,
        "gender": gender,
        "id": id,
        "known_for_department": knownForDepartment,
        "name": name,
        "original_name": originalName,
        "popularity": popularity,
        "profile_path": profilePath,
      };

  Crew toEntity() {
    return Crew(
      job: job,
      department: department,
      creditId: creditId,
      adult: adult,
      gender: gender,
      id: id,
      knownForDepartment: knownForDepartment,
      name: name,
      originalName: originalName,
      popularity: popularity,
      profilePath: profilePath,
    );
  }

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
