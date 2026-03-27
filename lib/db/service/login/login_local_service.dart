import 'package:hive/hive.dart';
import 'package:project_management/db/model/login/login_local_model.dart';
import 'package:project_management/feature/auth/model/login_response_model.dart';

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

  /// Save user login data from API response
  Future<void> saveLoginData(LoginResponseModel response) async {
    final loginData = LoginLocalModel.fromLoginResponse(response);
    await _loginBox.put(_userKey, loginData);
  }

  /// Save tokens only (useful for token refresh scenarios)
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final current = getLoginData();
    if (current != null) {
      final updated = current.copyWith(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      await _loginBox.put(_userKey, updated);
    } else {
      final newData = LoginLocalModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: '',
        userName: '',
        email: '',
        userType: '',
        userCode: '',
        permissionId: '',
        isActive: false,
        fullResponse: '',
      );
      await _loginBox.put(_userKey, newData);
    }
  }

  /// Retrieve the full login data
  LoginLocalModel? getLoginData() => _loginBox.get(_userKey);

  /// Update individual fields
  Future<void> updateAccessToken(String value) async {
    final current = getLoginData();
    if (current != null) {
      await _loginBox.put(_userKey, current.copyWith(accessToken: value));
    } else {
      final newData = LoginLocalModel(
        accessToken: value,
        refreshToken: '',
        userId: '',
        userName: '',
        email: '',
        userType: '',
        userCode: '',
        permissionId: '',
        isActive: false,
        fullResponse: '',
      );
      await _loginBox.put(_userKey, newData);
    }
  }

  Future<void> updateRefreshToken(String value) async {
    final current = getLoginData();
    if (current != null) {
      await _loginBox.put(_userKey, current.copyWith(refreshToken: value));
    } else {
      final newData = LoginLocalModel(
        accessToken: '',
        refreshToken: value,
        userId: '',
        userName: '',
        email: '',
        userType: '',
        userCode: '',
        permissionId: '',
        isActive: false,
        fullResponse: '',
      );
      await _loginBox.put(_userKey, newData);
    }
  }

  Future<void> updateUserProfile({
    String? userName,
    String? email,
    String? image,
  }) async {
    final current = getLoginData();
    if (current != null) {
      await _loginBox.put(
        _userKey,
        current.copyWith(
          userName: userName ?? current.userName,
          email: email ?? current.email,
          image: image ?? current.image,
        ),
      );
    }
  }

  /// Delete all login data (on logout)
  Future<void> clearLoginData() async => await _loginBox.delete(_userKey);

  /// Close the Hive box (optional)
  Future<void> dispose() async => await _loginBox.close();

  // ---------- Convenience Getters ----------
  String? get accessToken => getLoginData()?.accessToken;
  String? get refreshToken => getLoginData()?.refreshToken;
  String? get userId => getLoginData()?.userId;
  String? get userName => getLoginData()?.userName;
  String? get email => getLoginData()?.email;
  String? get userType => getLoginData()?.userType;
  String? get userCode => getLoginData()?.userCode;
  String? get permissionId => getLoginData()?.permissionId;
  String? get image => getLoginData()?.image;
  bool get isActive => getLoginData()?.isActive ?? false;
  LoginResponseModel? get loginResponse => getLoginData()?.toLoginResponse();

  /// Get full response JSON
  String? get fullResponseJson => getLoginData()?.fullResponse;

  /// Check if user is logged in (based on token and user data)
  bool get isLoggedIn {
    final data = getLoginData();
    return (data?.accessToken.isNotEmpty ?? false) && 
           (data?.userId.isNotEmpty ?? false);
  }

  /// Check if user has admin privileges (example)
  bool get isAdmin => userType?.toLowerCase() == 'admin';

  /// Check if user has specific permission (example)
  bool hasPermission(String permission) {
    return permissionId?.contains(permission) ?? false;
  }

  /// Get user display name (fallback to email if name is empty)
  String get displayName {
    final data = getLoginData();
    if (data?.userName.isNotEmpty ?? false) {
      return data!.userName;
    }
    return data?.email ?? 'Guest';
  }

  /// Clear only tokens (keep user info for re-login)
  Future<void> clearTokensOnly() async {
    final current = getLoginData();
    if (current != null) {
      await _loginBox.put(
        _userKey,
        current.copyWith(
          accessToken: '',
          refreshToken: '',
        ),
      );
    }
  }

  /// Get user profile as a map for easy use in UI
  Map<String, dynamic>? get userProfile {
    final data = getLoginData();
    if (data == null) return null;
    
    return {
      'userId': data.userId,
      'userName': data.userName,
      'email': data.email,
      'userType': data.userType,
      'userCode': data.userCode,
      'image': data.image,
      'isActive': data.isActive,
    };
  }
}