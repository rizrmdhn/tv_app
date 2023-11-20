import 'package:core/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String creditId;
  final String name;
  final int gender;
  final String? profilePath;

  const UserModel({
    required this.id,
    required this.creditId,
    required this.name,
    required this.gender,
    required this.profilePath,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        creditId: json["credit_id"],
        name: json["name"],
        gender: json["gender"],
        profilePath: json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "credit_id": creditId,
        "name": name,
        "gender": gender,
        "profile_path": profilePath,
      };

  User toEntity() {
    return User(
      id: id,
      creditId: creditId,
      name: name,
      gender: gender,
      profilePath: profilePath,
    );
  }

  @override
  List<Object?> get props => [
        id,
        creditId,
        name,
        gender,
        profilePath,
      ];
}
