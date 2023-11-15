import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton/presentation/provider/on_airing_today_notifer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'on_airing_today_notifer_test.mocks.dart';

@GenerateMocks([
  GetAiringTodayTv,
])
void main() {
  late OnAiringTodayNotifier provider;
  late MockGetAiringTodayTv mockGetAiringTodayTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetAiringTodayTv = MockGetAiringTodayTv();
    provider = OnAiringTodayNotifier(
      getAiringTodayTv: mockGetAiringTodayTv,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  const tTvList = <Tv>[];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetAiringTodayTv.execute())
        .thenAnswer((_) async => const Right(tTvList));
    // act
    provider.fetchOnAiringTodayTv();
    // assert
    expect(provider.state, RequestState.loading);
    expect(listenerCallCount, 1);
  });

  test('should change tvs data when data is gotten successfully', () async {
    // arrange
    when(mockGetAiringTodayTv.execute())
        .thenAnswer((_) async => const Right(tTvList));
    // act
    await provider.fetchOnAiringTodayTv();
    // assert
    expect(provider.state, RequestState.loaded);
    expect(provider.onAiringTodayTv, tTvList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetAiringTodayTv.execute())
        .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
    // act
    await provider.fetchOnAiringTodayTv();
    // assert
    expect(provider.state, RequestState.error);
    expect(provider.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
