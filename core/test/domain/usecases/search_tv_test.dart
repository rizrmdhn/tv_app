import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/search_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SearchTv(mockTvRepository);
  });

  const tQuery = 'spiderman';
  const tTvList = <Tv>[];

  test('should get list of tv from the repository', () async {
    // arrange
    when(mockTvRepository.searchTvs(tQuery))
        .thenAnswer((_) async => const Right(tTvList));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, const Right(tTvList));
  });
}
