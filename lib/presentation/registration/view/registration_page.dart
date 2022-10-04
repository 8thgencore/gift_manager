import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gift_manager/extensions/build_context.dart';
import 'package:gift_manager/extensions/theme_extensions.dart';
import 'package:gift_manager/presentation/home/view/home_page.dart';
import 'package:gift_manager/presentation/registration/bloc/registration_bloc.dart';
import 'package:gift_manager/resources/app_colors.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationBloc(),
      child: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationCompleted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            );
          }
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(),
            body: const _RegistrationPageWidget(),
          ),
        ),
      ),
    );
  }
}

class _RegistrationPageWidget extends StatefulWidget {
  const _RegistrationPageWidget();

  @override
  State<_RegistrationPageWidget> createState() => _RegistrationPageWidgetState();
}

class _RegistrationPageWidgetState extends State<_RegistrationPageWidget> {
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _passwordConfirmationFocusNode;
  late final FocusNode _nameFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _passwordConfirmationFocusNode = FocusNode();
    _nameFocusNode = FocusNode();

    SchedulerBinding.instance.addPostFrameCallback((_) => _addFocusLostHandlers());
  }

  void _addFocusLostHandlers() {
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<RegistrationBloc>().add(const RegistrationEmailFocusLost());
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<RegistrationBloc>().add(const RegistrationPasswordFocusLost());
      }
    });
    _passwordConfirmationFocusNode.addListener(() {
      if (!_passwordConfirmationFocusNode.hasFocus) {
        context.read<RegistrationBloc>().add(const RegistrationPasswordConfirmationFocusLost());
      }
    });
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        context.read<RegistrationBloc>().add(const RegistrationNameFocusLost());
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmationFocusNode.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Создать аккаунт', style: context.theme.h2),
              ),
              const SizedBox(height: 24),
              _EmailTextField(
                emailFocusNode: _emailFocusNode,
                passwordFocusNode: _passwordFocusNode,
              ),
              _PasswordTextField(
                passwordFocusNode: _passwordFocusNode,
                passwordConfirmationFocusNode: _passwordConfirmationFocusNode,
              ),
              _PasswordConfirmationTextField(
                passwordConfirmationFocusNode: _passwordConfirmationFocusNode,
                nameFocusNode: _nameFocusNode,
              ),
              _NameTextField(nameFocusNode: _nameFocusNode),
              const SizedBox(height: 24),
              const _AvatarWidget(),
            ],
          ),
        ),
        const _RegisterButton(),
      ],
    );
  }
}

class _EmailTextField extends StatelessWidget {
  const _EmailTextField({
    required FocusNode emailFocusNode,
    required FocusNode passwordFocusNode,
  })  : _emailFocusNode = emailFocusNode,
        _passwordFocusNode = passwordFocusNode;

  final FocusNode _emailFocusNode;
  final FocusNode _passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) => current is RegistrationFieldsInfo,
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.emailError;
          return TextField(
            focusNode: _emailFocusNode,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            onChanged: (text) =>
                context.read<RegistrationBloc>().add(RegistrationEmailChanged(text)),
            onSubmitted: (_) => _passwordFocusNode.requestFocus(),
            decoration: InputDecoration(
              labelText: 'Почта',
              errorText: error?.toString(),
            ),
          );
        },
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({
    required FocusNode passwordFocusNode,
    required FocusNode passwordConfirmationFocusNode,
  })  : _passwordFocusNode = passwordFocusNode,
        _passwordConfirmationFocusNode = passwordConfirmationFocusNode;

  final FocusNode _passwordFocusNode;
  final FocusNode _passwordConfirmationFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) => current is RegistrationFieldsInfo,
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.passwordError;
          return TextField(
            focusNode: _passwordFocusNode,
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            onChanged: (text) =>
                context.read<RegistrationBloc>().add(RegistrationPasswordChanged(text)),
            onSubmitted: (_) => _passwordConfirmationFocusNode.requestFocus(),
            decoration: InputDecoration(
              labelText: 'Пароль',
              errorText: error?.toString(),
            ),
          );
        },
      ),
    );
  }
}

class _PasswordConfirmationTextField extends StatelessWidget {
  const _PasswordConfirmationTextField({
    required FocusNode passwordConfirmationFocusNode,
    required FocusNode nameFocusNode,
  })  : _passwordConfirmationFocusNode = passwordConfirmationFocusNode,
        _nameFocusNode = nameFocusNode;

  final FocusNode _passwordConfirmationFocusNode;
  final FocusNode _nameFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) => current is RegistrationFieldsInfo,
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.passwordConfirmError;
          return TextField(
            focusNode: _passwordConfirmationFocusNode,
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            onChanged: (text) =>
                context.read<RegistrationBloc>().add(RegistrationPasswordConfirmationChanged(text)),
            onSubmitted: (_) => _nameFocusNode.requestFocus(),
            decoration: InputDecoration(
              labelText: 'Пароль второй раз',
              errorText: error?.toString(),
            ),
          );
        },
      ),
    );
  }
}

class _NameTextField extends StatelessWidget {
  const _NameTextField({
    required FocusNode nameFocusNode,
  }) : _nameFocusNode = nameFocusNode;

  final FocusNode _nameFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) => current is RegistrationFieldsInfo,
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.nameError;
          return TextField(
            focusNode: _nameFocusNode,
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
            onChanged: (text) =>
                context.read<RegistrationBloc>().add(RegistrationNameChanged(text)),
            onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            decoration: InputDecoration(
              labelText: 'Имя и фамилия',
              errorText: error?.toString(),
            ),
          );
        },
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(left: 8, top: 6, bottom: 6, right: 4),
      decoration: BoxDecoration(
        color: context.dynamicPlainColor(
          lightThemeColor: AppColors.lightLightBlue100,
          darkThemeColor: AppColors.darkWhite20,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          BlocBuilder<RegistrationBloc, RegistrationState>(
            buildWhen: (_, current) => current is RegistrationFieldsInfo,
            builder: (context, state) {
              final fieldsInfo = state as RegistrationFieldsInfo;
              return SvgPicture.network(
                fieldsInfo.avatarLink,
                height: 48,
                width: 48,
              );
            },
          ),
          const SizedBox(width: 8),
          Text('Ваш аватар', style: context.theme.h3),
          const SizedBox(width: 8),
          const Spacer(),
          TextButton(
            onPressed: () => context.read<RegistrationBloc>().add(const RegistrationChangeAvatar()),
            child: const Text('Изменить'),
          ),
        ],
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: BlocSelector<RegistrationBloc, RegistrationState, bool>(
          selector: (state) => state is RegistrationInProgress,
          builder: (context, inProgress) {
            return ElevatedButton(
              onPressed: inProgress
                  ? null
                  : () => context.read<RegistrationBloc>().add(const RegistrationCreateAccount()),
              child: const Text('Создать'),
            );
          },
        ),
      ),
    );
  }
}
