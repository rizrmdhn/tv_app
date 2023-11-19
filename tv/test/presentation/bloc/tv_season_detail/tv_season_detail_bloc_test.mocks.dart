// Mocks generated by Mockito 5.4.3 from annotations
// in tv/test/presentation/bloc/tv_season_detail/tv_season_detail_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:core/common/failure.dart' as _i6;
import 'package:core/domain/entities/season_detail.dart' as _i7;
import 'package:core/domain/repositories/tv_repository.dart' as _i2;
import 'package:core/domain/usecases/get_tv_season_detail.dart' as _i4;
import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeTvRepository_0 extends _i1.SmartFake implements _i2.TvRepository {
  _FakeTvRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_1<L, R> extends _i1.SmartFake implements _i3.Either<L, R> {
  _FakeEither_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GetTvSeasonDetail].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetTvSeasonDetail extends _i1.Mock implements _i4.GetTvSeasonDetail {
  MockGetTvSeasonDetail() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.TvRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeTvRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.TvRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, _i7.SeasonDetail>> execute(
    int? id,
    int? seasonNumber,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [
            id,
            seasonNumber,
          ],
        ),
        returnValue:
            _i5.Future<_i3.Either<_i6.Failure, _i7.SeasonDetail>>.value(
                _FakeEither_1<_i6.Failure, _i7.SeasonDetail>(
          this,
          Invocation.method(
            #execute,
            [
              id,
              seasonNumber,
            ],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i7.SeasonDetail>>);
}
