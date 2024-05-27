// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserCredentialsAdapter extends TypeAdapter<UserCredentials> {
  @override
  final int typeId = 1;

  @override
  UserCredentials read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserCredentials(
      email: fields[0] as String,
      password: fields[1] as String,
      token: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserCredentials obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCredentialsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
