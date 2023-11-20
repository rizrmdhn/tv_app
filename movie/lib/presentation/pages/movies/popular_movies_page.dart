import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_bloc.dart';

class PopularMoviesPage extends StatefulWidget {
  static const routeName = '/popular-movie';

  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<PopularMovieBloc>().add(LoadPopularMovie()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<PopularMovieBloc>(
          create: (context) => context.read<PopularMovieBloc>(),
          child: BlocConsumer<PopularMovieBloc, PopularMovieState>(
            listener: (context, state) {
              if (state is PopularMovieError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is PopularMovieLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PopularMovieHasData) {
                return ListView.builder(
                  itemCount: state.popularMovie.length,
                  itemBuilder: (context, index) {
                    final movie = state.popularMovie[index];
                    return MovieCard(movie);
                  },
                );
              } else if (state is PopularMovieHasNoData) {
                return Center(
                  child: Text(state.message),
                );
              } else if (state is PopularMovieError) {
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
      ),
    );
  }
}
