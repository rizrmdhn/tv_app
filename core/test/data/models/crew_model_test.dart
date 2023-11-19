import 'package:core/data/models/crew_model.dart';
import 'package:core/domain/entities/crew.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tCrewModel = CrewModel(
    job: 'job',
    department: 'department',
    creditId: 'creditId',
    adult: false,
    gender: 1,
    id: 1,
    knownForDepartment: 'knownForDepartment',
    name: 'name',
    originalName: 'originalName',
    popularity: 1,
    profilePath: 'profilePath',
  );

  const tCrew = Crew(
    job: 'job',
    department: 'department',
    creditId: 'creditId',
    adult: false,
    gender: 1,
    id: 1,
    knownForDepartment: 'knownForDepartment',
    name: 'name',
    originalName: 'originalName',
    popularity: 1,
    profilePath: 'profilePath',
  );

  test('should be a subclass of Crew entity', () async {
    final result = tCrewModel.toEntity();
    expect(result, tCrew);
  });
}
