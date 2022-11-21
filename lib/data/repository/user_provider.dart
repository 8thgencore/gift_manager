abstract class UserProvider {
  Future<bool> setUser(final String? user);

  Future<String?> getUser();
}
