import 'package:core/data/models/season_detail_model.dart';
import 'package:core/domain/entities/season_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tSeasonDetailModel = SeasonDetailModel(
    airDate: 'airDate',
    episodes: [],
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    seasonNumber: 1,
    voteAverage: 1,
  );

  const tSeasonDetail = SeasonDetail(
    airDate: 'airDate',
    episodes: [],
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    seasonNumber: 1,
    voteAverage: 1,
  );

  test('should be a subclass of SeasonDetail entity', () async {
    final result = tSeasonDetailModel.toEntity();
    expect(result, tSeasonDetail);
  });

  test('should convert to json correctly', () async {
    final seasonDetailJson = tSeasonDetailModel.toJson();

    expect(seasonDetailJson, isMap);
  });
}
