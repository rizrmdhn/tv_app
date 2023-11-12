import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_season_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TvSeasonDetailPage extends StatefulWidget {
  static const routeName = '/tv-season-detail';

  final int id;
  final int seasonNumber;
  const TvSeasonDetailPage({
    super.key,
    required this.id,
    required this.seasonNumber,
  });

  @override
  State<TvSeasonDetailPage> createState() => _TvSeasonDetailPageState();
}

class _TvSeasonDetailPageState extends State<TvSeasonDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TvSeasonDetailNotifier>(context, listen: false)
          .fetchTvSeasonDetail(widget.id, widget.seasonNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvSeasonDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvSeasonDetailState == RequestState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.tvSeasonDetailState == RequestState.loaded) {
            final seasonDetail = provider.tvSeasonDetail;
            return SafeArea(
              child: DetailContent(
                seasonDetail,
              ),
            );
          } else {
            return Center(
              child: Text(provider.tvSeasonDetailState.toString()),
            );
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final SeasonDetail seasonDetail;

  const DetailContent(this.seasonDetail, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${seasonDetail.posterPath}',
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
                              seasonDetail.name,
                              style: kHeading5,
                            ),
                            // ElevatedButton(
                            //   onPressed: () async {
                            //     if (!isAddedWatchlist) {
                            //       await Provider.of<TvDetailNotifier>(context,
                            //               listen: false)
                            //           .addWatchlist(tv);
                            //     } else {
                            //       await Provider.of<TvDetailNotifier>(context,
                            //               listen: false)
                            //           .removeFromWatchlist(tv);
                            //     }

                            //     final message = Provider.of<TvDetailNotifier>(
                            //             context,
                            //             listen: false)
                            //         .watchlistMessage;

                            //     if (message ==
                            //             TvDetailNotifier
                            //                 .watchlistAddSuccessMessage ||
                            //         message ==
                            //             TvDetailNotifier
                            //                 .watchlistRemoveSuccessMessage) {
                            //       ScaffoldMessenger.of(context).showSnackBar(
                            //           SnackBar(content: Text(message)));
                            //     } else {
                            //       showDialog(
                            //           context: context,
                            //           builder: (context) {
                            //             return AlertDialog(
                            //               content: Text(message),
                            //             );
                            //           });
                            //     }
                            //   },
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       isAddedWatchlist
                            //           ? const Icon(Icons.check)
                            //           : const Icon(Icons.add),
                            //       const Text('Watchlist'),
                            //     ],
                            //   ),
                            // ),
                            // Text(
                            //   _showGenres(seasonDetail.genres),
                            // ),
                            // Text(
                            //   _showDuration(seasonDetail.episodeRunTime),
                            // ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: seasonDetail.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${seasonDetail.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              seasonDetail.overview,
                            ),
                            const SizedBox(height: 16),
                            // Text(
                            //   'Recommendations',
                            //   style: kHeading6,
                            // ),
                            // Consumer<TvDetailNotifier>(
                            //   builder: (context, data, child) {
                            //     if (data.recommendationState ==
                            //         RequestState.loading) {
                            //       return const Center(
                            //         child: Padding(
                            //           padding: EdgeInsets.all(8.0),
                            //           child: CircularProgressIndicator(),
                            //         ),
                            //       );
                            //     } else if (data.recommendationState ==
                            //         RequestState.error) {
                            //       return Text(data.message);
                            //     } else if (data.recommendationState ==
                            //         RequestState.loaded) {
                            //       return SizedBox(
                            //           height: 150,
                            //           child: recommendations.isEmpty
                            //               ? const Center(
                            //                   child: Text(
                            //                     'No recommendations found',
                            //                   ),
                            //                 )
                            //               : ListView.builder(
                            //                   scrollDirection: Axis.horizontal,
                            //                   itemBuilder: (context, index) {
                            //                     final tv =
                            //                         recommendations[index];
                            //                     return Padding(
                            //                       padding:
                            //                           const EdgeInsets.all(4.0),
                            //                       child: InkWell(
                            //                         onTap: () {
                            //                           Navigator
                            //                               .pushReplacementNamed(
                            //                             context,
                            //                             TvSeasonDetailPage
                            //                                 .routeName,
                            //                             arguments: tv.id,
                            //                           );
                            //                         },
                            //                         child: ClipRRect(
                            //                           borderRadius:
                            //                               const BorderRadius
                            //                                   .all(
                            //                             Radius.circular(8),
                            //                           ),
                            //                           child: CachedNetworkImage(
                            //                             imageUrl:
                            //                                 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                            //                             placeholder:
                            //                                 (context, url) =>
                            //                                     const Center(
                            //                               child: Padding(
                            //                                 padding:
                            //                                     EdgeInsets.all(
                            //                                         8.0),
                            //                                 child:
                            //                                     CircularProgressIndicator(),
                            //                               ),
                            //                             ),
                            //                             errorWidget: (context,
                            //                                     url, error) =>
                            //                                 const Icon(
                            //                                     Icons.error),
                            //                           ),
                            //                         ),
                            //                       ),
                            //                     );
                            //                   },
                            //                   itemCount: recommendations.length,
                            //                 ));
                            //     } else {
                            //       return Container();
                            //     }
                            //   },
                            // ),
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

  // String _showGenres(List<Genre> genres) {
  //   String result = '';
  //   for (var genre in genres) {
  //     result += '${genre.name}, ';
  //   }

  //   if (result.isEmpty) {
  //     return result;
  //   }

  //   return result.substring(0, result.length - 2);
  // }

  // String _showDuration(int runtime) {
  //   final int hours = runtime ~/ 60;
  //   final int minutes = runtime % 60;

  //   if (hours > 0) {
  //     return '${hours}h ${minutes}m';
  //   } else {
  //     return '${minutes}m';
  //   }
  // }
}
