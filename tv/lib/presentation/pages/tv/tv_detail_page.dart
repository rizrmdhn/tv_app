import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_production_companies/tv_production_companies_bloc.dart';
import 'package:tv/presentation/bloc/tv_recommendation/tv_recommendation_bloc.dart';
import 'package:tv/presentation/bloc/tv_seasons/tv_seasons_bloc.dart';
import 'package:tv/presentation/bloc/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:tv/presentation/pages/tv/tv_season_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TvDetailPage extends StatefulWidget {
  static const routeName = '/tv-detail';

  final int id;
  const TvDetailPage({super.key, required this.id});

  @override
  State<TvDetailPage> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailBloc>().add(LoadTvDetail(widget.id));
      context.read<TvProductionCompaniesBloc>().add(
            LoadTvProductionCompanies(
              widget.id,
            ),
          );
      context.read<TvSeasonsBloc>().add(
            LoadTvSeasons(
              widget.id,
            ),
          );
      context.read<TvRecommendationBloc>().add(
            LoadTvRecommendation(
              widget.id,
            ),
          );
      context.read<TvWatchlistBloc>().add(
            LoadSavedTvWatchlist(
              widget.id,
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAddedToWatchlist = context.select<TvWatchlistBloc, bool>(
      (watchlist) => (watchlist.state is TvWatchlistIsAdded)
          ? (watchlist.state as TvWatchlistIsAdded).isAdded
          : false,
    );

    return Scaffold(
      body: BlocBuilder<TvDetailBloc, TvDetailState>(
        builder: (context, state) {
          if (state is TvDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvDetailHasData) {
            return SafeArea(
              child: DetailContent(
                state.tvDetail,
                isAddedToWatchlist,
              ),
            );
          } else if (state is TvDetailError) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.2,
                child: const Center(
                  child: Text('Failed to fetch data'),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class DetailContent extends StatefulWidget {
  final TvDetail tv;
  final bool isAddedWatchlist;

  const DetailContent(this.tv, this.isAddedWatchlist, {super.key});

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  bool isAddedWatchlist = false;

  @override
  void initState() {
    super.initState();
    isAddedWatchlist = widget.isAddedWatchlist;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${widget.tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tv.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context
                                      .read<TvWatchlistBloc>()
                                      .add(AddTvWatchlist(widget.tv));
                                } else {
                                  context
                                      .read<TvWatchlistBloc>()
                                      .add(RemoveTvWatchlist(widget.tv));
                                }

                                final state =
                                    BlocProvider.of<TvWatchlistBloc>(context)
                                        .state;
                                String message = '';

                                if (state is TvWatchlistIsAdded) {
                                  message = state.isAdded == false
                                      ? 'Added to watchlist'
                                      : 'Removed from watchlist';
                                } else {
                                  message = !isAddedWatchlist
                                      ? 'Added to watchlist'
                                      : 'Removed from watchlist';
                                }

                                if (message == 'Added to watchlist' ||
                                    message == 'Removed from watchlist') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(message),
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(message),
                                      );
                                    },
                                  );
                                }

                                setState(() {
                                  isAddedWatchlist = !isAddedWatchlist;
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(widget.tv.genres),
                            ),
                            Text(
                              _showSeasonsCount(widget.tv.seasons),
                            ),
                            Text(
                              _showNumberOfEpisodes(widget.tv.seasons),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.tv.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              widget.tv.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Production Companies',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvProductionCompaniesBloc,
                                TvProductionCompaniesState>(
                              builder: (context, state) {
                                if (state is TvProductionCompaniesLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state
                                    is TvProductionCompaniesHasData) {
                                  final companies = state.result;
                                  if (companies.isEmpty) {
                                    return const SizedBox(
                                      height: 150,
                                      child: Center(
                                        child: Text('No production companies'),
                                      ),
                                    );
                                  }
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final company = companies[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                child: CachedNetworkImage(
                                                  width: 150,
                                                  imageUrl:
                                                      'https://image.tmdb.org/t/p/w500${company.logoPath}',
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Icon(
                                                    Icons.error,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: companies.length,
                                    ),
                                  );
                                } else if (state
                                    is TvProductionCompaniesError) {
                                  return Center(
                                    key: const Key('error_message'),
                                    child: Text(state.message),
                                  );
                                } else {
                                  return Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      child: const Center(
                                        child: Text('Failed to fetch data'),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvSeasonsBloc, TvSeasonsState>(
                              builder: (context, state) {
                                if (state is TvSeasonsLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is TvSeasonsHasData) {
                                  final seasons = state.result;
                                  if (seasons.isEmpty) {
                                    return const SizedBox(
                                      height: 150,
                                      child: Center(
                                        child: Text('No seasons'),
                                      ),
                                    );
                                  }
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final season = seasons[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  TvSeasonDetailPage.routeName,
                                                  arguments: {
                                                    'id': widget.tv.id,
                                                    'tvName': widget.tv.name,
                                                    'seasonNumber':
                                                        season.seasonNumber,
                                                  });
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${season.posterPath}',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(
                                                  Icons.error,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: seasons.length,
                                    ),
                                  );
                                } else if (state is TvSeasonsError) {
                                  return Center(
                                    key: const Key('error_message'),
                                    child: Text(state.message),
                                  );
                                } else {
                                  return Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      child: const Center(
                                        child: Text('Failed to fetch data'),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvRecommendationBloc,
                                TvRecommendationState>(
                              builder: (context, state) {
                                if (state is TvRecommendationLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is TvRecommendationHasData) {
                                  final tvs = state.result;
                                  if (tvs.isEmpty) {
                                    return const SizedBox(
                                      height: 150,
                                      child: Center(
                                        child: Text('No recommendations'),
                                      ),
                                    );
                                  }
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv = tvs[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvDetailPage.routeName,
                                                arguments: tv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: tvs.length,
                                    ),
                                  );
                                } else if (state is TvRecommendationError) {
                                  return Center(
                                    key: const Key('error_message'),
                                    child: Text(state.message),
                                  );
                                } else {
                                  return Center(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      child: const Center(
                                        child: Text('Failed to fetch data'),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showSeasonsCount(List<Season> seasons) {
    return '${seasons.length} Seasons';
  }

  String _showNumberOfEpisodes(List<Season> seasons) {
    int result = 0;
    for (var season in seasons) {
      result += season.episodeCount;
    }

    return '$result Episodes from all seasons';
  }
}
