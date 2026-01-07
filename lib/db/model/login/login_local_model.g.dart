// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginLocalModelAdapter extends TypeAdapter<LoginLocalModel> {
  @override
  final int typeId = 1;

  @override
  LoginLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginLocalModel(
      accessToken: fields[0] as String,
      refreshToken: fields[1] as String,
      userId: fields[2] as String,
      userName: fields[3] as String,
      email: fields[4] as String,
      userType: fields[5] as String,
      userCode: fields[6] as String,
      permissionId: fields[7] as String,
      image: fields[8] as String?,
      isActive: fields[9] as bool,
      fullResponse: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LoginLocalModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.accessToken)
      ..writeByte(1)
      ..write(obj.refreshToken)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.userName)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.userType)
      ..writeByte(6)
      ..write(obj.userCode)
      ..writeByte(7)
      ..write(obj.permissionId)
      ..writeByte(8)
      ..write(obj.image)
      ..writeByte(9)
      ..write(obj.isActive)
      ..writeByte(10)
      ..write(obj.fullResponse);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
