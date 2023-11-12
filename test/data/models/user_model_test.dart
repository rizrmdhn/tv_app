import 'package:ditonton/data/models/user_model.dart';
import 'package:ditonton/domain/entities/user.dart';
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
}
