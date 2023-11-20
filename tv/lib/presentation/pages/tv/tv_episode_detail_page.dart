import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/episode_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tv/presentation/bloc/tv_episode_detail/tv_episode_detail_bloc.dart';

class TvEpisodeDetailPage extends StatefulWidget {
  static const routeName = '/tv-episode-detail';

  final int id;
  final int seasonNumber;
  final int episodeNumber;

  const TvEpisodeDetailPage({
    super.key,
    required this.id,
    required this.seasonNumber,
    required this.episodeNumber,
  });

  @override
  State<TvEpisodeDetailPage> createState() => _TvSeasonDetailPageState();
}

class _TvSeasonDetailPageState extends State<TvEpisodeDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        context.read<TvEpisodeDetailBloc>().add(
              TvEpisodeDetailLoad(
                widget.id,
                widget.seasonNumber,
                widget.episodeNumber,
              ),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvEpisodeDetailBloc, TvEpisodeDetailState>(
        builder: (context, state) {
          if (state is TvEpisodeDetailLoaded) {
            return DetailContent(state.tvEpisodeDetail);
          } else if (state is TvEpisodeDetailError) {
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

class DetailContent extends StatelessWidget {
  final EpisodeDetail episodeDetail;

  const DetailContent(this.episodeDetail, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${episodeDetail.stillPath}',
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
                              episodeDetail.name!,
                              style: kHeading5,
                            ),
                            Text(
                              _showEpisodeDuration(episodeDetail.runtime!),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: episodeDetail.voteAverage! / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${episodeDetail.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              episodeDetail.overview ?? 'No overview found.',
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

  String _showEpisodeDuration(int duration) {
    final minutes = duration % 60;
    return ' $minutes min';
  }
}
