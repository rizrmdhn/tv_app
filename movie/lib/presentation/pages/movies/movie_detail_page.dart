import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_recommendation/movie_recommendation_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/movie-detail';

  final int id;
  const MovieDetailPage({super.key, required this.id});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieDetailBloc>().add(LoadMovieDetail(widget.id));
      context
          .read<MovieRecommendationBloc>()
          .add(LoadMovieRecommendation(widget.id));
      context
          .read<WatchlistMovieBloc>()
          .add(LoadSavedMovieWatchlist(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAddedToWatchlist = context.select<WatchlistMovieBloc, bool>(
      (watchlistMovieBloc) =>
          (watchlistMovieBloc.state is WatchlistMovieIsAdded)
              ? (watchlistMovieBloc.state as WatchlistMovieIsAdded).isAdded
              : false,
    );

    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailHasData) {
            final movie = state.movieDetail;
            return SafeArea(
              child: DetailContent(
                movie,
                isAddedToWatchlist,
              ),
            );
          } else if (state is MovieDetailError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class DetailContent extends StatefulWidget {
  final MovieDetail movie;
  final bool isAddedWatchlist;

  const DetailContent(this.movie, this.isAddedWatchlist, {super.key});

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
          imageUrl: 'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
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
                              widget.movie.title,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context
                                      .read<WatchlistMovieBloc>()
                                      .add(AddMovieWatchlist(widget.movie));
                                } else {
                                  context
                                      .read<WatchlistMovieBloc>()
                                      .add(RemoveMovieWatchlist(widget.movie));
                                }

                                final state =
                                    BlocProvider.of<WatchlistMovieBloc>(context)
                                        .state;
                                String message = '';

                                if (state is WatchlistMovieIsAdded) {
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
                              _showGenres(widget.movie.genres),
                            ),
                            Text(
                              _showDuration(widget.movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.movie.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              widget.movie.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<MovieRecommendationBloc,
                                MovieRecommendationState>(
                              builder: (context, state) {
                                if (state is MovieRecommendationLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state
                                    is MovieRecommendationHasData) {
                                  final movies = state.movieRecommendation;
                                  return SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: movies.length,
                                      itemBuilder: (context, index) {
                                        final movie = movies[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/movie-detail',
                                                arguments: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                width: 120,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else if (state
                                    is MovieRecommendationHasNoData) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                      child: Text(state.message),
                                    ),
                                  );
                                } else if (state is MovieRecommendationError) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                      child: Text(state.message),
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
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

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
