import 'package:hive/hive.dart';

part 'profile_local_model.g.dart';

@HiveType(typeId: 3)
class ProfileLocalModel {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? mobile;

  @HiveField(3)
  final String? email;

  @HiveField(4)
  final String? photo;

  @HiveField(5)
  final String? birthday;

  @HiveField(6)
  final String? profession;

  @HiveField(7)
  final String? education;

  @HiveField(8)
  final String? address;

  @HiveField(9)
  final int? gender; // ✅ Match API type

  const ProfileLocalModel({
    this.id,
    this.name,
    this.mobile,
    this.email,
    this.photo,
    this.birthday,
    this.profession,
    this.education,
    this.address,
    this.gender,
  });

  factory ProfileLocalModel.fromJson(Map<String, dynamic> json) {
    return ProfileLocalModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      mobile: json['mobile'] as String?,
      email: json['email'] as String?,
      photo: json['photo'] as String?,
      birthday: json['birthday'] as String?,
      profession: json['profession'] as String?,
      education: json['education'] as String?,
      address: json['address'] as String?,
      gender: json['gender'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'email': email,
      'photo': photo,
      'birthday': birthday,
      'profession': profession,
      'education': education,
      'address': address,
      'gender': gender,
    };
  }

  ProfileLocalModel copyWith({
    int? id,
    String? name,
    String? mobile,
    String? email,
    String? photo,
    String? birthday,
    String? profession,
    String? education,
    String? address,
    int? gender,
  }) {
    return ProfileLocalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      photo: photo ?? this.photo,
      birthday: birthday ?? this.birthday,
      profession: profession ?? this.profession,
      education: education ?? this.education,
      address: address ?? this.address,
      gender: gender ?? this.gender,
    );
  }
}
