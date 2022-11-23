import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_manager/di/service_locator.dart';
import 'package:gift_manager/presentation/gifts/bloc/gifts_bloc.dart';

class GiftsPage extends StatelessWidget {
  const GiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<GiftsBloc>()..add(const GiftsPageLoaded()),
      child: const _GiftsPageWidget(),
    );
  }
}

class _GiftsPageWidget extends StatelessWidget {
  const _GiftsPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<GiftsBloc, GiftsState>(
        builder: (context, state) {
          if (state is InitialGiftsLoadingState) {
            //TODO show loading state
          } else if (state is NoGiftsState) {
            //TODO show no gifts state
          } else if (state is InitialLoadingErrorState) {
            //TODO loading error state
          } else if (state is LoadedGiftsState) {
            //TODO show gifts
          }
          debugPrint('Unknown state: $state');
          //TODO loading error state

          return const Text('HomePage');
        },
      ),
    );
  }
}
