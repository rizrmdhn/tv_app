import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/on_airing_today_notifer.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      () => Provider.of<OnAiringTodayNotifier>(context, listen: false)
          .fetchOnAiringTodayTv(),
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
        child: Consumer<OnAiringTodayNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data.onAiringTodayTv[index];
                  return TvCard(tv);
                },
                itemCount: data.onAiringTodayTv.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
