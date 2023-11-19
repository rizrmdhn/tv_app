import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/production_company.dart';
import 'package:core/domain/usecases/get_tv_production_company.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvProductionCompany usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvProductionCompany(mockTvRepository);
  });

  const tId = 1;
  final tProductionCompany = [
    const ProductionCompany(
      id: 1,
      logoPath: '/logoPath',
      name: 'name',
      originCountry: 'originCountry',
    ),
  ];

  test('should get list of production company from the repository', () async {
    // arrange
    when(mockTvRepository.getTvProductionCompany(tId))
        .thenAnswer((_) async => Right(tProductionCompany));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tProductionCompany));
    verify(mockTvRepository.getTvProductionCompany(tId));
    verifyNoMoreInteractions(mockTvRepository);
  });
}
