import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetAiringTodayTv,
  GetOnTheAirTv,
  GetPopularTv,
  GetTopRatedTv,
])
void main() {
  late TvListNotifier provider;
  late MockGetAiringTodayTv mockGetAiringTodayTv;
  late MockGetOnTheAirTv mockGetOnTheAirTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetTopRatedTv mockGetTopRatedTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetAiringTodayTv = MockGetAiringTodayTv();
    mockGetOnTheAirTv = MockGetOnTheAirTv();
    mockGetPopularTv = MockGetPopularTv();
    mockGetTopRatedTv = MockGetTopRatedTv();
    provider = TvListNotifier(
      getAiringTodayTvs: mockGetAiringTodayTv,
      getOnTheAirTvs: mockGetOnTheAirTv,
      getPopularTvs: mockGetPopularTv,
      getTopRatedTvs: mockGetTopRatedTv,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  const tTv = Tv(
    adult: false,
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originalCountry: ['originCountry'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvList = <Tv>[tTv];

  group('Get Airing Today Tvs', () {
    test('initialState should be Empty', () {
      expect(provider.airingTodayState, equals(RequestState.empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetAiringTodayTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchAiringTodayTvs();
      // assert
      expect(provider.airingTodayState, RequestState.loading);
      expect(listenerCallCount, 1);
    });

    test('should change airing today tvs data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetAiringTodayTv.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchAiringTodayTvs();
      // assert
      expect(provider.airingTodayState, RequestState.loaded);
      expect(provider.airingTodayTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetAiringTodayTv.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchAiringTodayTvs();
      // assert
      expect(provider.airingTodayState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('Get On The Air Tvs', () {
    test('initialState should be Empty', () {
      expect(provider.onTheAirState, equals(RequestState.empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetOnTheAirTv.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchOnTheAirTvs();
      // assert
      expect(provider.onTheAirState, RequestState.loading);
      expect(listenerCallCount, 1);
    });

    test('should change on the air tvs data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetOnTheAirTv.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchOnTheAirTvs();
      // assert
      expect(provider.onTheAirState, RequestState.loaded);
      expect(provider.onTheAirTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetOnTheAirTv.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchOnTheAirTvs();
      // assert
      expect(provider.onTheAirState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('Get Popular Tvs', () {
    test('initialState should be Empty', () {
      expect(provider.popularState, equals(RequestState.empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchPopularTvs();
      // assert
      expect(provider.popularState, RequestState.loading);
      expect(listenerCallCount, 1);
    });

    test('should change popular tvs data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchPopularTvs();
      // assert
      expect(provider.popularState, RequestState.loaded);
      expect(provider.popularTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTvs();
      // assert
      expect(provider.popularState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('Get Top Rated Tvs', () {
    test('initialState should be Empty', () {
      expect(provider.topRatedState, equals(RequestState.empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchTopRatedTvs();
      // assert
      expect(provider.topRatedState, RequestState.loading);
      expect(listenerCallCount, 1);
    });

    test('should change top rated tvs data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchTopRatedTvs();
      // assert
      expect(provider.topRatedState, RequestState.loaded);
      expect(provider.topRatedTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTvs();
      // assert
      expect(provider.topRatedState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
