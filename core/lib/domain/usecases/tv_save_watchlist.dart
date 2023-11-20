import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/repositories/tv_repository.dart';

class TvSaveWatchList {
  final TvRepository repository;

  TvSaveWatchList(this.repository);

  Future<Either<Failure, String>> execute(TvDetail tvs) async {
    return await repository.saveWatchlist(tvs);
  }
}
