import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_search_notifier_test.mocks.dart';

@GenerateMocks([
  SearchTv,
])
void main() {
  late TvSearchNotifier provider;
  late MockSearchTv mockSearchTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTv = MockSearchTv();
    provider = TvSearchNotifier(
      searchTv: mockSearchTv,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  const tTvList = <Tv>[];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockSearchTv.execute('tv'))
        .thenAnswer((_) async => const Right(tTvList));
    // act
    provider.fetchTvSearch('tv');
    // assert
    expect(provider.state, RequestState.loading);
    expect(listenerCallCount, 1);
  });

  test('should change tvs data when data is gotten successfully', () async {
    // arrange
    when(mockSearchTv.execute('tv'))
        .thenAnswer((_) async => const Right(tTvList));
    // act
    await provider.fetchTvSearch('tv');
    // assert
    expect(provider.state, RequestState.loaded);
    expect(provider.searchResult, tTvList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockSearchTv.execute('tv'))
        .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
    // act
    await provider.fetchTvSearch('tv');
    // assert
    expect(provider.state, RequestState.error);
    expect(provider.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
