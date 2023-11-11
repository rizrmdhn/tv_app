import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/production_company.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetTvProductionCompany {
  final TvRepository repository;

  GetTvProductionCompany(this.repository);

  Future<Either<Failure, List<ProductionCompany>>> execute(int id) async {
    return await repository.getTvProductionCompany(id);
  }
}
