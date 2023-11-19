import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/on_the_air/on_the_air_bloc.dart';

class OnTheAirPage extends StatefulWidget {
  static const routeName = '/on-the-air-tv';

  const OnTheAirPage({super.key});

  @override
  State<OnTheAirPage> createState() => _OnTheAirPageState();
}

class _OnTheAirPageState extends State<OnTheAirPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<OnTheAirBloc>().add(LoadOnTheAirTv()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On The Air TV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirBloc, OnTheAirState>(
          builder: (context, state) {
            if (state is OnTheAirLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is OnTheAirHasData) {
              final tvs = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = tvs[index];
                  return TvCard(tv);
                },
                itemCount: tvs.length,
              );
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
      ),
    );
  }
}
