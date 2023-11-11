import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetTvSeasons {
  final TvRepository repository;

  GetTvSeasons(this.repository);

  Future<Either<Failure, List<Season>>> execute(int id) async {
    return await repository.getTvSeasons(id);
  }
}
