import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/production_company.dart';
import 'package:core/domain/usecases/get_tv_production_company.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/tv_production_companies/tv_production_companies_bloc.dart';

import 'tv_production_companies_bloc_test.mocks.dart';

@GenerateMocks([GetTvProductionCompany])
void main() {
  late TvProductionCompaniesBloc bloc;
  late MockGetTvProductionCompany mockGetTvProductionCompany;

  setUp(() {
    mockGetTvProductionCompany = MockGetTvProductionCompany();
    bloc = TvProductionCompaniesBloc(mockGetTvProductionCompany);
  });

  const tId = 1;
  const tTvProductionCompany = ProductionCompany(
    id: 1,
    logoPath: '/logoPath',
    name: 'name',
    originCountry: 'originCountry',
  );

  test('initial state should be empty', () {
    expect(bloc.state, equals(TvProductionCompaniesInitial()));
  });

  blocTest<TvProductionCompaniesBloc, TvProductionCompaniesState>(
    'should emit [loading, loaded] when data is gotten successfully',
    build: () {
      when(mockGetTvProductionCompany.execute(tId))
          .thenAnswer((_) async => const Right([tTvProductionCompany]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvProductionCompanies(tId)),
    expect: () => [
      TvProductionCompaniesLoading(),
      const TvProductionCompaniesHasData([tTvProductionCompany]),
    ],
    verify: (_) {
      verify(mockGetTvProductionCompany.execute(tId));
      return LoadTvProductionCompanies(tId).props.contains(tId);
    },
  );

  blocTest<TvProductionCompaniesBloc, TvProductionCompaniesState>(
    'should emit [loading, error] when get data is unsuccessful',
    build: () {
      when(mockGetTvProductionCompany.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvProductionCompanies(tId)),
    expect: () => [
      TvProductionCompaniesLoading(),
      const TvProductionCompaniesError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetTvProductionCompany.execute(tId));
      return LoadTvProductionCompanies(tId).props.contains(tId);
    },
  );

  blocTest<TvProductionCompaniesBloc, TvProductionCompaniesState>(
    'should emit [loading, no data] when get data is empty',
    build: () {
      when(mockGetTvProductionCompany.execute(tId))
          .thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvProductionCompanies(tId)),
    expect: () => [
      TvProductionCompaniesLoading(),
      const TvProductionCompaniesNoData('No Data'),
    ],
    verify: (_) {
      verify(mockGetTvProductionCompany.execute(tId));
      return LoadTvProductionCompanies(tId).props.contains(tId);
    },
  );
}
