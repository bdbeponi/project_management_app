import 'package:hive/hive.dart';

part 'remember_me_model.g.dart'; // correct path

@HiveType(typeId: 2)
class RememberMeModel {
  @HiveField(0)
  final String phone;

  @HiveField(1)
  final String password;

  const RememberMeModel({
    required this.phone,
    required this.password,
  });
}
