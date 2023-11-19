import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/episode_detail.dart';
import 'package:core/domain/entities/production_company.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/entities/season_detail.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';

abstract class TvRepository {
  Future<Either<Failure, List<Tv>>> getAiringTodayTvs();
  Future<Either<Failure, List<Tv>>> getOnTheAirTvs();
  Future<Either<Failure, List<Tv>>> getPopularTvs();
  Future<Either<Failure, List<Tv>>> getTopRatedTvs();
  Future<Either<Failure, TvDetail>> getTvDetail(int id);
  Future<Either<Failure, List<ProductionCompany>>> getTvProductionCompany(
      int id);
  Future<Either<Failure, List<Season>>> getTvSeasons(int id);
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id);
  Future<Either<Failure, SeasonDetail>> getTvSeasonDetail(
    int id,
    int seasonNumber,
  );
  Future<Either<Failure, EpisodeDetail>> getTvEpisodeDetail(
    int id,
    int seasonNumber,
    int episodeNumber,
  );
  Future<Either<Failure, List<Tv>>> searchTvs(String query);
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv);
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv);
  Future<bool> isAddedToWatchlistTv(int id);
  Future<Either<Failure, List<Tv>>> getWatchlistTvs();
}
