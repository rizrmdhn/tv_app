import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_tv_notifier_test.mocks.dart';

@GenerateMocks([
  GetWatchListTv,
])
void main() {
  late WatchlistTvNotifier provider;
  late MockGetWatchListTv mockGetWatchListTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchListTv = MockGetWatchListTv();
    provider = WatchlistTvNotifier(
      getWatchlistTv: mockGetWatchListTv,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  const tTvList = <Tv>[];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetWatchListTv.execute())
        .thenAnswer((_) async => const Right(tTvList));
    // act
    provider.fetchWatchlistTv();
    // assert
    expect(provider.watchlistState, RequestState.loading);
    expect(listenerCallCount, 1);
  });

  test('should change tvs data when data is gotten successfully', () async {
    // arrange
    when(mockGetWatchListTv.execute())
        .thenAnswer((_) async => const Right(tTvList));
    // act
    await provider.fetchWatchlistTv();
    // assert
    expect(provider.watchlistState, RequestState.loaded);
    expect(provider.message, '');
    expect(provider.watchlistTv, tTvList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetWatchListTv.execute())
        .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
    // act
    await provider.fetchWatchlistTv();
    // assert
    expect(provider.watchlistState, RequestState.error);
    expect(provider.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
