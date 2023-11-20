import 'package:core/data/models/genre_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tGenreModel = GenreModel(id: 1, name: 'name');

  test('should be a subclass of Genre entity', () async {
    expect(tGenreModel, isA<GenreModel>());
  });

  test('should convert to json correctly', () async {
    final result = tGenreModel.toJson();

    expect(result, isMap);
  });
}
