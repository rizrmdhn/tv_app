import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/repositories/tv_repository.dart';

class GetTvSeasons {
  final TvRepository repository;

  GetTvSeasons(this.repository);

  Future<Either<Failure, List<Season>>> execute(int id) async {
    return await repository.getTvSeasons(id);
  }
}
