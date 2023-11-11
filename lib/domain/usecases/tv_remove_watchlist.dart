import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class TvRemoveWatchList {
  final TvRepository repository;

  TvRemoveWatchList(this.repository);

  Future<Either<Failure, String>> execute(TvDetail tv) async {
    return await repository.removeWatchlist(tv);
  }
}
