import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/production_company.dart';
import 'package:core/domain/repositories/tv_repository.dart';

class GetTvProductionCompany {
  final TvRepository repository;

  GetTvProductionCompany(this.repository);

  Future<Either<Failure, List<ProductionCompany>>> execute(int id) async {
    return await repository.getTvProductionCompany(id);
  }
}
