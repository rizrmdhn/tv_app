abstract class TvLocalDataSource {
  Future<String> insertWatchlist(int id);
  Future<String> removeWatchlist(int id);
  Future<bool> isAddedToWatchlist(int id);
  Future<List<int>> getWatchlistTv();
}
