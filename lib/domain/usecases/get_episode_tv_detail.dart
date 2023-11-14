import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/episode_detail.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetEpisodeTvDetail {
  final TvRepository repository;

  GetEpisodeTvDetail(this.repository);

  Future<Either<Failure, EpisodeDetail>> execute(
      int id, int seasonNumber, int episodeNumber) {
    return repository.getTvEpisodeDetail(id, seasonNumber, episodeNumber);
  }
}
