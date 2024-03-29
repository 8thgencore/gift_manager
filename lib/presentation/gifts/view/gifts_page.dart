import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gift_manager/data/http/model/gift_dto.dart';
import 'package:gift_manager/di/service_locator.dart';
import 'package:gift_manager/presentation/gifts/bloc/gifts_bloc.dart';
import 'package:gift_manager/resources/app_colors.dart';
import 'package:gift_manager/resources/illustrations.dart';

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
  const _GiftsPageWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<GiftsBloc, GiftsState>(
        builder: (context, state) {
          if (state is InitialGiftsLoadingState) {
            return const _LoadingWidget();
          } else if (state is NoGiftsState) {
            return const _NoGiftsWidget();
          } else if (state is InitialLoadingErrorState) {
            return const _InitialLoadingErrorWidget();
          } else if (state is LoadedGiftsState) {
            return _GiftsListWidget(
              gifts: state.gifts,
              showLoading: state.showLoading,
              showError: state.showError,
            );
          }
          debugPrint('Unknown state: $state');
          return const Center(child: Text('GIFTS PAGE'));
        },
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _NoGiftsWidget extends StatelessWidget {
  const _NoGiftsWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        SvgPicture.asset(Illustrations.noGifts),
        const SizedBox(height: 38),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Добавьте свой первый подарок',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _InitialLoadingErrorWidget extends StatelessWidget {
  const _InitialLoadingErrorWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        SvgPicture.asset(Illustrations.noGifts),
        const SizedBox(height: 38),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Произошла ошибка',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ElevatedButton(
            onPressed: () => context.read<GiftsBloc>().add(const GiftsLoadingRequest()),
            child: Text(
              'Попробовать снова'.toUpperCase(),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _GiftsListWidget extends StatefulWidget {
  const _GiftsListWidget({
    required this.gifts,
    required this.showLoading,
    required this.showError,
  });

  final List<GiftDto> gifts;
  final bool showLoading;
  final bool showError;

  @override
  State<_GiftsListWidget> createState() => _GiftsListWidgetState();
}

class _GiftsListWidgetState extends State<_GiftsListWidget> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        if (_scrollController.position.extentAfter < 300) {
          context.read<GiftsBloc>().add(const GiftsAutoLoadingRequest());
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: widget.gifts.length + 1 + (_haveExtraWidget ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Text(
            'Подарки:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
          );
        }
        if (index == widget.gifts.length + 1) {
          if (widget.showLoading) {
            return Container(
              height: 128,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          } else {
            if (!widget.showError) {
              debugPrint('index = gifts.length + 1 but showLoading = false && showError = false');
            }
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              height: 128,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFFFE8F2),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Не удалось подгрузить данные'),
                  const Text('Попробуйте еще раз'),
                  TextButton(
                    onPressed: () => context.read<GiftsBloc>().add(const GiftsLoadingRequest()),
                    child: const Text('Попробовать еще раз'),
                  ),
                ],
              ),
            );
          }
        }
        final gift = widget.gifts[index - 1];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // TODO
            color: const Color(0xFFFF0F2F7),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                gift.name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
              ),
              const SizedBox(height: 6),
              const Text(
                'Подпись подарка',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.lightGrey100,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool get _haveExtraWidget => widget.showLoading || widget.showError;
}
