import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_manager/data/modal/request_error.dart';
import 'package:gift_manager/presentation/home/view/home_page.dart';
import 'package:gift_manager/presentation/login/bloc/login_bloc.dart';
import 'package:gift_manager/presentation/login/model/email_error.dart';
import 'package:gift_manager/presentation/login/model/password_error.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: const Scaffold(
        body: _LoginPageWidget(),
      ),
    );
  }
}

class _LoginPageWidget extends StatefulWidget {
  const _LoginPageWidget({super.key});

  @override
  State<_LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<_LoginPageWidget> {
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.authenticated) {
              Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }
          },
        ),
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.requestError != RequestError.noError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                  'Произошла ошибка',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red[900],
              ));
              context.read<LoginBloc>().add(const LoginRequestErrorShowed());
            }
          },
        ),
      ],
      child: Column(
        children: [
          // Expanded(flex: 4, child: SizedBox.expand()),
          const SizedBox(height: 64),
          const Center(
            child: Text(
              'Вход',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
          ),
          const Spacer(flex: 5),
          _EmailTextField(
            emailFocusNode: _emailFocusNode,
            passwordFocusNode: _passwordFocusNode,
          ),
          const SizedBox(height: 8),
          _PasswordTextField(passwordFocusNode: _passwordFocusNode),
          const SizedBox(height: 40),
          const _LoginButton(),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Еще нет аккаунта?"),
              TextButton(
                onPressed: () => debugPrint('Нажали на кнопку Создать'),
                child: const Text('Создать'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => debugPrint('Нажали на кнопку Не помню пароль'),
            child: const Text('Не помню пароль'),
          ),
          const Spacer(flex: 16),
        ],
      ),
    );
  }
}

class _EmailTextField extends StatelessWidget {
  const _EmailTextField({
    required FocusNode emailFocusNode,
    required FocusNode passwordFocusNode,
    super.key,
  })  : _emailFocusNode = emailFocusNode,
        _passwordFocusNode = passwordFocusNode;

  final FocusNode _emailFocusNode;
  final FocusNode _passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: BlocSelector<LoginBloc, LoginState, EmailError>(
        selector: (state) => state.emailError,
        builder: (context, emailError) {
          return TextField(
            focusNode: _emailFocusNode,
            onChanged: (text) =>
                context.read<LoginBloc>().add(LoginEmailChanged(text)),
            onSubmitted: (_) => _passwordFocusNode.requestFocus(),
            decoration: InputDecoration(
              hintText: 'Почта',
              errorText: emailError == EmailError.noError
                  ? null
                  : emailError.toString(),
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
    super.key,
  }) : _passwordFocusNode = passwordFocusNode;

  final FocusNode _passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: BlocSelector<LoginBloc, LoginState, PasswordError>(
        selector: (state) => state.passwordError,
        builder: (context, passwordError) {
          return TextField(
            focusNode: _passwordFocusNode,
            onChanged: (text) =>
                context.read<LoginBloc>().add(LoginPasswordChanged(text)),
            onSubmitted: (_) =>
                context.read<LoginBloc>().add(const LoginLoginButtonClicked()),
            decoration: InputDecoration(
              hintText: 'Пароль',
              errorText: passwordError == PasswordError.noError
                  ? null
                  : passwordError.toString(),
            ),
          );
        },
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: SizedBox(
        width: double.infinity,
        child: BlocSelector<LoginBloc, LoginState, bool>(
          selector: (state) => state.allFieldsValid,
          builder: (context, fieldsValid) {
            return ElevatedButton(
              onPressed: fieldsValid
                  ? () => context
                      .read<LoginBloc>()
                      .add(const LoginLoginButtonClicked())
                  : null,
              child: const Text('Войти'),
            );
          },
        ),
      ),
    );
  }
}
