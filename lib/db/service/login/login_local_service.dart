import 'package:hive/hive.dart';
import 'package:project_management/db/model/login/login_local_model.dart';

class LoginLocalService {
  static const String _boxName = 'login_local_box';
  static const String _userKey = 'logged_in_user';

  static final LoginLocalService _instance = LoginLocalService._internal();
  factory LoginLocalService() => _instance;
  LoginLocalService._internal();

  late Box<LoginLocalModel> _loginBox;

  /// Initialize Hive and open the box (must be called before usage)
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(LoginLocalModelAdapter());
    }
    _loginBox = await Hive.openBox<LoginLocalModel>(_boxName);
  }

  /// Save accessToken and refreshToken
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final updated = LoginLocalModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    await _loginBox.put(_userKey, updated);
  }

  /// Retrieve the full token data
  LoginLocalModel? getTokens() => _loginBox.get(_userKey);

  /// Update individual token
  Future<void> setAccessToken(String value) async {
    final current = getTokens();
    if (current != null) {
      await _loginBox.put(_userKey, current.copyWith(accessToken: value));
    } else {
      await saveTokens(accessToken: value, refreshToken: '');
    }
  }

  Future<void> setRefreshToken(String value) async {
    final current = getTokens();
    if (current != null) {
      await _loginBox.put(_userKey, current.copyWith(refreshToken: value));
    } else {
      await saveTokens(accessToken: '', refreshToken: value);
    }
  }

  /// Delete all token data (on logout)
  Future<void> deleteTokens() async => await _loginBox.delete(_userKey);

  /// Close the Hive box (optional)
  Future<void> dispose() async => await _loginBox.close();

  // ---------- Individual Token Accessors ----------
  String? get accessToken => getTokens()?.accessToken;
  String? get refreshToken => getTokens()?.refreshToken;

  /// Check if user is logged in (based on token)
  bool get isLoggedIn => (getTokens()?.accessToken.isNotEmpty ?? false);
}
