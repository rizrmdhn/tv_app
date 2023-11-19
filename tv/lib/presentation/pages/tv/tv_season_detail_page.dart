import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/season_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/tv_season_detail/tv_season_detail_bloc.dart';
import 'package:tv/presentation/pages/tv/tv_episode_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TvSeasonDetailPage extends StatefulWidget {
  static const routeName = '/tv-season-detail';

  final String tvName;
  final int id;
  final int seasonNumber;

  const TvSeasonDetailPage({
    super.key,
    required this.tvName,
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
      context.read<TvSeasonDetailBloc>().add(
            LoadTvSeasonDetail(
              widget.id,
              widget.seasonNumber,
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvSeasonDetailBloc, TvSeasonDetailState>(
        builder: (context, state) {
          if (state is TvSeasonDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvSeasonDetailLoaded) {
            final seasonDetail = state.seasonDetail;
            return SafeArea(
              child: DetailContent(
                widget.tvName,
                widget.id,
                seasonDetail,
              ),
            );
          } else if (state is TvSeasonDetailError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text('Failed to fetch data'),
            );
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final String tvName;
  final int tvId;
  final SeasonDetail seasonDetail;

  const DetailContent(this.tvName, this.tvId, this.seasonDetail, {super.key});

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
                              tvName,
                              style: kHeading5,
                            ),
                            Text(
                              seasonDetail.name,
                              style: kHeading6,
                            ),
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
                              seasonDetail.overview.isEmpty
                                  ? 'No overview found'
                                  : seasonDetail.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Episodes (${seasonDetail.episodes.length})',
                              style: kHeading6,
                            ),
                            SizedBox(
                              height: 150,
                              child: seasonDetail.episodes.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'No episodes',
                                      ),
                                    )
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final episodes =
                                            seasonDetail.episodes[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                  context,
                                                  TvEpisodeDetailPage.routeName,
                                                  arguments: {
                                                    'id': tvId,
                                                    'seasonNumber': seasonDetail
                                                        .seasonNumber,
                                                    'episodeNumber':
                                                        episodes.episodeNumber
                                                  });
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: episodes!.stillPath !=
                                                        null
                                                    ? 'https://image.tmdb.org/t/p/w500${episodes.stillPath}'
                                                    : 'https://image.tmdb.org/t/p/w500${seasonDetail.posterPath}',
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
                                      itemCount: seasonDetail.episodes.length,
                                    ),
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
}
