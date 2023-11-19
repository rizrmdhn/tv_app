import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:about/about_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/pages/movies/home_movie_page.dart';
import 'package:tv/presentation/bloc/on_airing_today/on_airing_today_bloc.dart';
import 'package:tv/presentation/bloc/on_the_air/on_the_air_bloc.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:tv/presentation/pages/tv/on_the_air_page.dart';
import 'package:tv/presentation/pages/tv/on_airing_today_page.dart';
import 'package:tv/presentation/pages/tv/popular_tv_page.dart';
import 'package:tv/presentation/pages/tv/search_tv_page.dart';
import 'package:tv/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:tv/presentation/pages/tv/tv_detail_page.dart';
import 'package:tv/presentation/pages/tv/watchlist_tv_page.dart';
import 'package:flutter/material.dart';

class HomeTvPage extends StatefulWidget {
  static const routeName = '/tv';

  const HomeTvPage({super.key});

  @override
  State<HomeTvPage> createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OnAiringTodayBloc>().add(LoadOnAiringTodayTv());
      context.read<OnTheAirBloc>().add(LoadOnTheAirTv());
      context.read<PopularTvBloc>().add(LoadPopularTv());
      context.read<TopRatedTvBloc>().add(LoadTopRatedTv());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('Tv Series'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                Navigator.pop(context);
                Future.delayed(
                  const Duration(milliseconds: 500),
                  () => Navigator.pushReplacementNamed(
                    context,
                    HomeMoviePage.routeName,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTvPage.routeName);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.routeName);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Tv Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTvPage.routeName);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'On Airing Today',
                onTap: () =>
                    Navigator.pushNamed(context, OnAiringTodayPage.routeName),
              ),
              BlocBuilder<OnAiringTodayBloc, OnAiringTodayState>(
                builder: (context, state) {
                  if (state is OnAiringTodayLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is OnAiringTodayHasData) {
                    final tvs = state.result;
                    return TvList(tvs);
                  } else if (state is OnAiringTodayError) {
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
              _buildSubHeading(
                title: 'On The Air',
                onTap: () =>
                    Navigator.pushNamed(context, OnTheAirPage.routeName),
              ),
              BlocBuilder<OnTheAirBloc, OnTheAirState>(
                builder: (context, state) {
                  if (state is OnTheAirLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is OnTheAirHasData) {
                    final tvs = state.result;
                    return TvList(tvs);
                  } else if (state is OnTheAirError) {
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
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvPage.routeName),
              ),
              BlocBuilder<PopularTvBloc, PopularTvState>(
                builder: (context, state) {
                  if (state is PopularTvLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PopularTvHasData) {
                    final tvs = state.result;
                    return TvList(tvs);
                  } else if (state is PopularTvError) {
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
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTvPage.routeName),
              ),
              BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
                builder: (context, state) {
                  if (state is TopRatedTvLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TopRatedTvHasData) {
                    final tvs = state.tvs;
                    return TvList(tvs);
                  } else if (state is TopRatedTvError) {
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
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> tvs;

  const TvList(this.tvs, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.routeName,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${tv.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvs.length,
      ),
    );
  }
}
