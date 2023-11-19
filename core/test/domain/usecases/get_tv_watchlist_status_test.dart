import 'package:core/domain/usecases/get_tv_watchlist_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvWatchlistStatus usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvWatchlistStatus(mockTvRepository);
  });

  const tId = 1;
  const tIsAdded = true;

  test('should get tv watchlist status from the repository', () async {
    // arrange
    when(mockTvRepository.isAddedToWatchlistTv(tId))
        .thenAnswer((_) async => tIsAdded);
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, tIsAdded);
  });
}
