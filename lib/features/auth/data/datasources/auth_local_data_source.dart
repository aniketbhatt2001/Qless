import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<bool> isTokenValid();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;

  static const _tokenKey = 'userAuth';
  static const _savedAtKey = 'tokenSavedAt';

  AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
    await _prefs.setInt(_savedAtKey, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Future<String?> getToken() async => _prefs.getString(_tokenKey);

  @override
  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_savedAtKey);
  }

  @override
  Future<bool> isTokenValid() async {
    final token = _prefs.getString(_tokenKey);
    final savedAt = _prefs.getInt(_savedAtKey);
    if (token == null || savedAt == null) return false;
    final savedDate = DateTime.fromMillisecondsSinceEpoch(savedAt);
    return DateTime.now().difference(savedDate).inHours < 24;
  }
}
