import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_manager/di/service_locator.dart';
import 'package:gift_manager/navigation/route_name.dart';
import 'package:gift_manager/presentation/home/bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<HomeBloc>()..add(const HomePageLoaded()),
      child: const _HomePageWidget(),
    );
  }
}

class _HomePageWidget extends StatelessWidget {
  const _HomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeGoToLogin) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteName.login.route,
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeWithUser) {
                    return Text("${state.user.toString()}\n\n${state.gifts.join('\n')}");
                  }
                  return const Text('HomePage');
                },
              ),
              const SizedBox(height: 42),
              TextButton(
                onPressed: () async {
                  context.read<HomeBloc>().add(const HomeLogoutPushed());
                },
                child: const Text('Logout'),
              ),
              const SizedBox(height: 42),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed(RouteName.gifts.route),
                child: const Text('Open presents'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
