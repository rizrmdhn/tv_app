import 'package:about/about_page.dart';
import 'package:core/common/constants.dart';
import 'package:core/common/utils.dart';
import 'package:core/presentation/provider/movie_detail_notifier.dart';
import 'package:core/presentation/provider/movie_list_notifier.dart';
import 'package:core/presentation/provider/movie_search_notifier.dart';
import 'package:core/presentation/provider/now_playing_movies_notifier.dart';
import 'package:core/presentation/provider/on_airing_today_notifer.dart';
import 'package:core/presentation/provider/popular_movies_notifier.dart';
import 'package:core/presentation/provider/top_rated_movies_notifier.dart';
import 'package:core/presentation/provider/tv_detail_notifier.dart';
import 'package:core/presentation/provider/tv_episode_detail_notifier.dart';
import 'package:core/presentation/provider/tv_list_notifier.dart';
import 'package:core/presentation/provider/tv_search_notifier.dart';
import 'package:core/presentation/provider/tv_season_detail_notifier.dart';
import 'package:core/presentation/provider/watchlist_movie_notifier.dart';
import 'package:core/presentation/provider/watchlist_tv_notifier.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/search_movie/search_bloc.dart';
import 'package:movie/presentation/pages/movies/home_movie_page.dart';
import 'package:movie/presentation/pages/movies/movie_detail_page.dart';
import 'package:movie/presentation/pages/movies/now_playing_page.dart';
import 'package:movie/presentation/pages/movies/popular_movies_page.dart';
import 'package:movie/presentation/pages/movies/search_page.dart';
import 'package:movie/presentation/pages/movies/top_rated_movies_page.dart';
import 'package:movie/presentation/pages/movies/watchlist_movies_page.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:tv/presentation/bloc/on_airing_today/on_airing_today_bloc.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/search_tv/search_tv_bloc.dart';
import 'package:tv/presentation/bloc/on_the_air/on_the_air_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_episode_detail/tv_episode_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_recommendation/tv_recommendation_bloc.dart';
import 'package:tv/presentation/bloc/tv_production_companies/tv_production_companies_bloc.dart';
import 'package:tv/presentation/bloc/tv_season_detail/tv_season_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_seasons/tv_seasons_bloc.dart';
import 'package:tv/presentation/bloc/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:tv/presentation/pages/tv/home_tv_page.dart';
import 'package:tv/presentation/pages/tv/on_airing_today_page.dart';
import 'package:tv/presentation/pages/tv/on_the_air_page.dart';
import 'package:tv/presentation/pages/tv/popular_tv_page.dart';
import 'package:tv/presentation/pages/tv/search_tv_page.dart';
import 'package:tv/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:tv/presentation/pages/tv/tv_detail_page.dart';
import 'package:tv/presentation/pages/tv/tv_episode_detail_page.dart';
import 'package:tv/presentation/pages/tv/tv_season_detail_page.dart';
import 'package:tv/presentation/pages/tv/watchlist_tv_page.dart';

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<NowPlayingMoviesNotifier>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<OnAiringTodayBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<OnTheAirBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvProductionCompaniesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvRecommendationBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeasonsBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvWatchlistBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvSeasonDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvEpisodeDetailBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: const HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(
                builder: (_) => const HomeMoviePage(),
              );
            case NowPlayingPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const NowPlayingPage(),
              );
            case PopularMoviesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const PopularMoviesPage(),
              );
            case TopRatedMoviesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const TopRatedMoviesPage(),
              );
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const SearchPage(),
              );
            case WatchlistMoviesPage.routeName:
              return MaterialPageRoute(
                  builder: (_) => const WatchlistMoviesPage());
            case AboutPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const AboutPage(),
              );
            case HomeTvPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const HomeTvPage(),
              );
            case TvDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            case OnAiringTodayPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const OnAiringTodayPage(),
              );
            case OnTheAirPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const OnTheAirPage(),
              );
            case PopularTvPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const PopularTvPage(),
              );
            case TopRatedTvPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const TopRatedTvPage(),
              );
            case WatchlistTvPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const WatchlistTvPage(),
              );
            case SearchTvPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const SearchTvPage(),
              );
            case TvSeasonDetailPage.routeName:
              final arguments = settings.arguments as Map<String, dynamic>;
              final tvName = arguments['tvName'] as String;
              final tvId = arguments['id'] as int;
              final seasonNumber = arguments['seasonNumber'] as int;
              return CupertinoPageRoute(
                builder: (_) => TvSeasonDetailPage(
                  tvName: tvName,
                  id: tvId,
                  seasonNumber: seasonNumber,
                ),
                settings: settings,
              );
            case TvEpisodeDetailPage.routeName:
              final arguments = settings.arguments as Map<String, dynamic>;
              final tvId = arguments['id'] as int;
              final seasonNumber = arguments['seasonNumber'] as int;
              final episodeNumber = arguments['episodeNumber'] as int;
              return CupertinoPageRoute(
                builder: (_) => TvEpisodeDetailPage(
                  id: tvId,
                  seasonNumber: seasonNumber,
                  episodeNumber: episodeNumber,
                ),
                settings: settings,
              );
            default:
              return MaterialPageRoute(builder: (_) {
                return const Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
