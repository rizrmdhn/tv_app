import 'package:core/common/state_enum.dart';
import 'package:core/common/utils.dart';
import 'package:core/presentation/provider/watchlist_tv_notifier.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistTvPage extends StatefulWidget {
  static const routeName = '/watchlist-tv';

  const WatchlistTvPage({super.key});

  @override
  State<WatchlistTvPage> createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistTvPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchlistTvNotifier>(context, listen: false)
            .fetchWatchlistTv());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistTvNotifier>(context, listen: false).fetchWatchlistTv();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<WatchlistTvNotifier>(
          builder: (context, data, child) {
            if (data.watchlistState == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.watchlistState == RequestState.loaded) {
              if (data.watchlistTv.isEmpty) {
                return const Center(
                  child: Text('No watchlist tvs'),
                );
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final tv = data.watchlistTv[index];
                    return TvCard(tv);
                  },
                  itemCount: data.watchlistTv.length,
                );
              }
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
