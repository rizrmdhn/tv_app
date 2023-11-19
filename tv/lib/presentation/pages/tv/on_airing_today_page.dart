import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/on_airing_today/on_airing_today_bloc.dart';

class OnAiringTodayPage extends StatefulWidget {
  static const routeName = '/on-airing-today-tv';

  const OnAiringTodayPage({super.key});

  @override
  State<OnAiringTodayPage> createState() => _OnAiringTodayPageState();
}

class _OnAiringTodayPageState extends State<OnAiringTodayPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<OnAiringTodayBloc>().add(LoadOnAiringTodayTv()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On Airing Today TV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnAiringTodayBloc, OnAiringTodayState>(
          builder: (context, state) {
            if (state is OnAiringTodayLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is OnAiringTodayHasData) {
              final tvs = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = tvs[index];
                  return TvCard(tv);
                },
                itemCount: tvs.length,
              );
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
      ),
    );
  }
}
