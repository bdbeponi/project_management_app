import 'package:hive/hive.dart';

part 'login_local_model.g.dart';

@HiveType(typeId: 1)
class LoginLocalModel {
  @HiveField(0)
  final String accessToken;

  @HiveField(1)
  final String refreshToken;

  const LoginLocalModel({

    required this.accessToken,
    required this.refreshToken,
  });

  // CopyWith method
  LoginLocalModel copyWith({
    String? phone,
    String? password,
    String? accessToken,
    String? refreshToken,
  }) {
    return LoginLocalModel(

      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  // From JSON
  factory LoginLocalModel.fromJson(Map<String, dynamic> json) {
    return LoginLocalModel(

      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
