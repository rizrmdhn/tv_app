import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/repositories/tv_repository.dart';

class GetWatchListTv {
  final TvRepository repository;

  GetWatchListTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute() async {
    return await repository.getWatchlistTvs();
  }
}
