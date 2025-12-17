// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileLocalModelAdapter extends TypeAdapter<ProfileLocalModel> {
  @override
  final int typeId = 3;

  @override
  ProfileLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileLocalModel(
      id: fields[0] as int?,
      name: fields[1] as String?,
      mobile: fields[2] as String?,
      email: fields[3] as String?,
      photo: fields[4] as String?,
      birthday: fields[5] as String?,
      profession: fields[6] as String?,
      education: fields[7] as String?,
      address: fields[8] as String?,
      gender: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileLocalModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.mobile)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.photo)
      ..writeByte(5)
      ..write(obj.birthday)
      ..writeByte(6)
      ..write(obj.profession)
      ..writeByte(7)
      ..write(obj.education)
      ..writeByte(8)
      ..write(obj.address)
      ..writeByte(9)
      ..write(obj.gender);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
