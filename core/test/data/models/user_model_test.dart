import 'package:core/data/models/user_model.dart';
import 'package:core/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tUserModel = UserModel(
    id: 1,
    creditId: 'abcd',
    name: 'name',
    gender: 1,
    profilePath: '/path.jpg',
  );

  const tUser = User(
    id: 1,
    creditId: 'abcd',
    name: 'name',
    gender: 1,
    profilePath: '/path.jpg',
  );

  test('should be a subclass of User entity', () async {
    final result = tUserModel.toEntity();
    expect(result, tUser);
  });

  test('should convert from json correctly', () async {
    final jsonData = tUserModel.toJson();

    final result = UserModel.fromJson(jsonData);

    expect(result, tUserModel);
  });

  test('should get object from json correctly', () async {
    final jsonData = tUserModel.toJson();

    final result = UserModel.fromJson(jsonData);

    expect(result, isA<UserModel>());
  });
}
