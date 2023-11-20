import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const routeName = '/top-rated-movie';

  const TopRatedMoviesPage({super.key});

  @override
  State<TopRatedMoviesPage> createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TopRatedMovieBloc>().add(LoadTopRatedMovie()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
          builder: (context, state) {
            if (state is TopRatedMovieLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedMovieHasData) {
              return ListView.builder(
                itemCount: state.topRatedMovie.length,
                itemBuilder: (context, index) {
                  final movie = state.topRatedMovie[index];
                  return MovieCard(movie);
                },
              );
            } else if (state is TopRatedMovieHasNoData) {
              return Center(
                child: Text(state.message),
              );
            } else if (state is TopRatedMovieError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: Text(''),
              );
            }
          },
        ),
      ),
    );
  }
}
