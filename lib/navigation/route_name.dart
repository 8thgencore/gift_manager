import 'package:collection/collection.dart';

enum RouteName {
  gifts(route: '/gifts'),
  home(route: '/home'),
  login(route: '/login'),
  registration(route: '/registration'),
  resetPassword(route: '/reset_password'),
  splash(route: '/');

  const RouteName({required this.route});

  static RouteName? find(String? name) =>
      values.firstWhereOrNull((routeName) => routeName.route == name);

  final String route;
}
