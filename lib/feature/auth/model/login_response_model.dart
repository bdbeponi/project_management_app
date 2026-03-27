import 'dart:convert';

class LoginResponseModel {
  final int statusCode;
  final Data data;
  final String message;
  final bool success;

  LoginResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      statusCode: json["statusCode"] as int,
      data: Data.fromJson(json["data"] as Map<String, dynamic>),
      message: json["message"] as String,
      success: json["success"] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data.toJson(),
        "message": message,
        "success": success,
      };

  // Helper method for API calls
  factory LoginResponseModel.fromResponse(String responseBody) {
    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    return LoginResponseModel.fromJson(json);
  }

  String toRawJson() => json.encode(toJson());

  LoginResponseModel copyWith({
    int? statusCode,
    Data? data,
    String? message,
    bool? success,
  }) {
    return LoginResponseModel(
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
      message: message ?? this.message,
      success: success ?? this.success,
    );
  }

  @override
  String toString() {
    return 'LoginResponse(statusCode: $statusCode, message: $message, success: $success)';
  }
}

class Data {
  final User user;
  final String accessToken;
  final String refreshToken;

  Data({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      user: User.fromJson(json["user"] as Map<String, dynamic>),
      accessToken: json["accessToken"] as String,
      refreshToken: json["refreshToken"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };

  Data copyWith({
    User? user,
    String? accessToken,
    String? refreshToken,
  }) {
    return Data(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  @override
  String toString() {
    return 'Data(user: ${user.userName}, tokenLength: ${accessToken.length})';
  }
}

class User {
  final String id;
  final String userName;
  final String email;
  final String userType;
  final bool isActive;
  final String? image;
  final String permissionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final List<Map<String, dynamic>> social;
  final String userCode;
  final List<Map<String, dynamic>> address;
  final List<Map<String, dynamic>> documents;

  User({
    required this.id,
    required this.userName,
    required this.email,
    required this.userType,
    required this.isActive,
    this.image,
    required this.permissionId,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.social,
    required this.userCode,
    required this.address,
    required this.documents,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"] as String,
      userName: json["userName"] as String,
      email: json["email"] as String,
      userType: json["user_type"] as String,
      isActive: json["is_active"] as bool,
      image: json["image"] as String?,
      permissionId: json["permissionId"] as String,
      createdAt: DateTime.parse(json["createdAt"] as String),
      updatedAt: DateTime.parse(json["updatedAt"] as String),
      version: json["__v"] as int,
      social: (json["social"] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>() ??
          [],
      userCode: json["user_code"] as String,
      address: (json["address"] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>() ??
          [],
      documents: (json["documents"] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userName": userName,
        "email": email,
        "user_type": userType,
        "is_active": isActive,
        "image": image,
        "permissionId": permissionId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": version,
        "social": social,
        "user_code": userCode,
        "address": address,
        "documents": documents,
      };

  User copyWith({
    String? id,
    String? userName,
    String? email,
    String? userType,
    bool? isActive,
    String? image,
    String? permissionId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    List<Map<String, dynamic>>? social,
    String? userCode,
    List<Map<String, dynamic>>? address,
    List<Map<String, dynamic>>? documents,
  }) {
    return User(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      isActive: isActive ?? this.isActive,
      image: image ?? this.image,
      permissionId: permissionId ?? this.permissionId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      social: social ?? this.social,
      userCode: userCode ?? this.userCode,
      address: address ?? this.address,
      documents: documents ?? this.documents,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, userName: $userName, email: $email, type: $userType)';
  }
}