// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remember_me_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RememberMeModelAdapter extends TypeAdapter<RememberMeModel> {
  @override
  final int typeId = 2;

  @override
  RememberMeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RememberMeModel(
      phone: fields[0] as String,
      password: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RememberMeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.phone)
      ..writeByte(1)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RememberMeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
