import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/usecases/get_tv_season.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeasons usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvSeasons(mockTvRepository);
  });

  const tId = 1;
  const tTvSeasons = <Season>[];

  test('should get list of tv seasons from the repository', () async {
    // arrange
    when(mockTvRepository.getTvSeasons(tId))
        .thenAnswer((_) async => const Right(tTvSeasons));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, const Right(tTvSeasons));
  });
}
