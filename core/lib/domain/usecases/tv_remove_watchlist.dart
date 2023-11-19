import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/repositories/tv_repository.dart';

class TvRemoveWatchList {
  final TvRepository repository;

  TvRemoveWatchList(this.repository);

  Future<Either<Failure, String>> execute(TvDetail tv) async {
    return await repository.removeWatchlist(tv);
  }
}
