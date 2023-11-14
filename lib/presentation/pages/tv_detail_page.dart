import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/production_company.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/tv_season_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

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
      Provider.of<TvDetailNotifier>(context, listen: false)
          .fetchTvDetail(widget.id);
      Provider.of<TvDetailNotifier>(context, listen: false)
          .loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvState == RequestState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.tvState == RequestState.loaded) {
            final tv = provider.tv;
            return SafeArea(
              child: DetailContent(
                tv,
                provider.productionCompanies,
                provider.seasons,
                provider.tvRecommendations,
                provider.isAddedToWatchlist,
              ),
            );
          } else {
            return Center(
              child: Text(provider.tvState.toString()),
            );
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<ProductionCompany> productionCompanies;
  final List<Season> seasons;
  final List<Tv> recommendations;
  final bool isAddedWatchlist;

  const DetailContent(this.tv, this.productionCompanies, this.seasons,
      this.recommendations, this.isAddedWatchlist,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
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
                              tv.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  await Provider.of<TvDetailNotifier>(context,
                                          listen: false)
                                      .addWatchlist(tv);
                                } else {
                                  await Provider.of<TvDetailNotifier>(context,
                                          listen: false)
                                      .removeFromWatchlist(tv);
                                }

                                final message = Provider.of<TvDetailNotifier>(
                                        context,
                                        listen: false)
                                    .watchlistMessage;

                                if (message ==
                                        TvDetailNotifier
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        TvDetailNotifier
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
                                }
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
                              _showGenres(tv.genres),
                            ),
                            // Text(
                            //   _showDuration(tv.episodeRunTime),
                            // ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Production Companies',
                              style: kHeading6,
                            ),
                            Consumer<TvDetailNotifier>(
                              builder: (context, data, child) {
                                if (data.productionCompaniesState ==
                                    RequestState.loading) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (data.productionCompaniesState ==
                                    RequestState.error) {
                                  return Text(data.message);
                                } else if (data.productionCompaniesState ==
                                    RequestState.loaded) {
                                  return SizedBox(
                                      height: 150,
                                      child: productionCompanies.isEmpty
                                          ? const Center(
                                              child: Text(
                                                'No production companies found',
                                              ),
                                            )
                                          : ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                final tv =
                                                    productionCompanies[index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                      minWidth: 100,
                                                      maxWidth: 200,
                                                    ),
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(8),
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    child: InkWell(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(8),
                                                        ),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              'https://image.tmdb.org/t/p/w200${tv.logoPath}',
                                                          placeholder:
                                                              (context, url) =>
                                                                  const Center(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemCount:
                                                  productionCompanies.length,
                                            ));
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: kHeading6,
                            ),
                            Consumer<TvDetailNotifier>(
                              builder: (context, data, child) {
                                if (data.productionCompaniesState ==
                                    RequestState.loading) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (data.productionCompaniesState ==
                                    RequestState.error) {
                                  return Text(data.message);
                                } else if (data.productionCompaniesState ==
                                    RequestState.loaded) {
                                  return SizedBox(
                                      height: 150,
                                      child: productionCompanies.isEmpty
                                          ? const Center(
                                              child: Text(
                                                'No seasons found',
                                              ),
                                            )
                                          : ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                final season = seasons[index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator
                                                          .pushReplacementNamed(
                                                        context,
                                                        TvSeasonDetailPage
                                                            .routeName,
                                                        arguments: {
                                                          'id': tv.id,
                                                          'seasonNumber': season
                                                              .seasonNumber,
                                                        },
                                                      );
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(8),
                                                      ),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            'https://image.tmdb.org/t/p/w200${season.posterPath}',
                                                        placeholder:
                                                            (context, url) =>
                                                                const Center(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemCount: seasons.length,
                                            ));
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            Consumer<TvDetailNotifier>(
                              builder: (context, data, child) {
                                if (data.recommendationState ==
                                    RequestState.loading) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (data.recommendationState ==
                                    RequestState.error) {
                                  return Text(data.message);
                                } else if (data.recommendationState ==
                                    RequestState.loaded) {
                                  return SizedBox(
                                      height: 150,
                                      child: recommendations.isEmpty
                                          ? const Center(
                                              child: Text(
                                                'No recommendations found',
                                              ),
                                            )
                                          : ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                final tv =
                                                    recommendations[index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator
                                                          .pushReplacementNamed(
                                                        context,
                                                        TvDetailPage.routeName,
                                                        arguments: tv.id,
                                                      );
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(8),
                                                      ),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                                        placeholder:
                                                            (context, url) =>
                                                                const Center(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemCount: recommendations.length,
                                            ));
                                } else {
                                  return Container();
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
