import 'package:core/data/models/episode_detail_model.dart';
import 'package:core/domain/entities/episode_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tEpisodeDetailModel = EpisodeDetailModel(
    airDate: 'airDate',
    episodeNumber: 1,
    id: 1,
    name: 'name',
    overview: 'overview',
    productionCode: 'productionCode',
    runtime: 1,
    seasonNumber: 1,
    stillPath: 'stillPath',
    voteAverage: 1,
    voteCount: 1,
  );

  const tEpisodeDetail = EpisodeDetail(
    airDate: 'airDate',
    episodeNumber: 1,
    id: 1,
    name: 'name',
    overview: 'overview',
    productionCode: 'productionCode',
    runtime: 1,
    seasonNumber: 1,
    stillPath: 'stillPath',
    voteAverage: 1,
    voteCount: 1,
  );

  test('should be a subclass of EpisodeDetail entity', () async {
    final result = tEpisodeDetailModel.toEntity();
    expect(result, tEpisodeDetail);
  });

  test('should convert to json correctly', () async {
    final episodeDetailJson = tEpisodeDetailModel.toJson();

    expect(episodeDetailJson, isMap);
  });
}
