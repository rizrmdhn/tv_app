// Mocks generated by Mockito 5.0.8 from annotations
// in ditonton/test/presentation/pages/popular_movies_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i6;
import 'dart:ui' as _i7;

import 'package:ditonton/common/state_enum.dart' as _i4;
import 'package:ditonton/domain/entities/movie.dart' as _i5;
import 'package:ditonton/domain/usecases/get_popular_movies.dart' as _i2;
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeGetPopularMovies extends _i1.Fake implements _i2.GetPopularMovies {}

/// A class which mocks [PopularMoviesNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockPopularMoviesNotifier extends _i1.Mock
    implements _i3.PopularMoviesNotifier {
  MockPopularMoviesNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetPopularMovies get getPopularMovies =>
      (super.noSuchMethod(Invocation.getter(#getPopularMovies),
          returnValue: _FakeGetPopularMovies()) as _i2.GetPopularMovies);
  @override
  _i4.RequestState get state => (super.noSuchMethod(Invocation.getter(#state),
      returnValue: _i4.RequestState.empty) as _i4.RequestState);
  @override
  List<_i5.Movie> get movies => (super.noSuchMethod(Invocation.getter(#movies),
      returnValue: <_i5.Movie>[]) as List<_i5.Movie>);
  @override
  String get message =>
      (super.noSuchMethod(Invocation.getter(#message), returnValue: '')
          as String);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i6.Future<void> fetchPopularMovies() =>
      (super.noSuchMethod(Invocation.method(#fetchPopularMovies, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i6.Future<void>);
  @override
  void addListener(_i7.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i7.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}
