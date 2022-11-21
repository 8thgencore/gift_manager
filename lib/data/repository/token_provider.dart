abstract class TokenProvider {
  Future<bool> setToken(final String? token);

  Future<String?> getToken();
}
