import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:project_management/feature/auth/model/login_response_model.dart';

part 'login_local_model.g.dart';

@HiveType(typeId: 1)
class LoginLocalModel {
  @HiveField(0)
  final String accessToken;

  @HiveField(1)
  final String refreshToken;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final String userName;

  @HiveField(4)
  final String email;

  @HiveField(5)
  final String userType;

  @HiveField(6)
  final String userCode;

  @HiveField(7)
  final String permissionId;

  @HiveField(8)
  final String? image;

  @HiveField(9)
  final bool isActive;

  @HiveField(10)
  final String fullResponse; // Store the entire response as JSON string

  const LoginLocalModel({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.userName,
    required this.email,
    required this.userType,
    required this.userCode,
    required this.permissionId,
    this.image,
    required this.isActive,
    required this.fullResponse,
  });

  // Create from your API response model
  factory LoginLocalModel.fromLoginResponse(LoginResponseModel response) {
    return LoginLocalModel(
      accessToken: response.data.accessToken,
      refreshToken: response.data.refreshToken,
      userId: response.data.user.id,
      userName: response.data.user.userName,
      email: response.data.user.email,
      userType: response.data.user.userType,
      userCode: response.data.user.userCode,
      permissionId: response.data.user.permissionId,
      image: response.data.user.image,
      isActive: response.data.user.isActive,
      fullResponse: response.toRawJson(), // Store the entire response
    );
  }

  // From JSON
  factory LoginLocalModel.fromJson(Map<String, dynamic> json) {
    return LoginLocalModel(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      userType: json['userType'] ?? '',
      userCode: json['userCode'] ?? '',
      permissionId: json['permissionId'] ?? '',
      image: json['image'],
      isActive: json['isActive'] ?? false,
      fullResponse: jsonEncode(json['fullResponse']),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'userId': userId,
      'userName': userName,
      'email': email,
      'userType': userType,
      'userCode': userCode,
      'permissionId': permissionId,
      'image': image,
      'isActive': isActive,
      'fullResponse': fullResponse,
    };
  }

  // CopyWith method
  LoginLocalModel copyWith({
    String? accessToken,
    String? refreshToken,
    String? userId,
    String? userName,
    String? email,
    String? userType,
    String? userCode,
    String? permissionId,
    String? image,
    bool? isActive,
    String? fullResponse,
  }) {
    return LoginLocalModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      userCode: userCode ?? this.userCode,
      permissionId: permissionId ?? this.permissionId,
      image: image ?? this.image,
      isActive: isActive ?? this.isActive,
      fullResponse: fullResponse ?? this.fullResponse,
    );
  }

  // Convert back to your original model if needed
  LoginResponseModel toLoginResponse() {
    return LoginResponseModel.fromResponse(fullResponse);
  }
}
