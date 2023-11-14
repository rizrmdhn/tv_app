import 'package:ditonton/data/models/guest_stars_model.dart';
import 'package:ditonton/domain/entities/guest_stars.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tGuestStarsModel = GuestStarsModel(
    character: 'character',
    creditId: 'creditId',
    order: 1,
    adult: false,
    gender: 1,
    id: 1,
    knownForDepartment: 'knownForDepartment',
    name: 'name',
    originalName: 'originalName',
    popularity: 1,
    profilePath: 'profilePath',
  );

  const tGuestStars = GuestStars(
    character: 'character',
    creditId: 'creditId',
    order: 1,
    adult: false,
    gender: 1,
    id: 1,
    knownForDepartment: 'knownForDepartment',
    name: 'name',
    originalName: 'originalName',
    popularity: 1,
    profilePath: 'profilePath',
  );

  test('should be a subclass of GuestStars entity', () async {
    final result = tGuestStarsModel.toEntity();
    expect(result, tGuestStars);
  });
}
