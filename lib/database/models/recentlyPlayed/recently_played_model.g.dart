// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_played_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentlyPlayedModelAdapter extends TypeAdapter<RecentlyPlayedModel> {
  @override
  final int typeId = 3;

  @override
  RecentlyPlayedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentlyPlayedModel(
      id: fields[0] as int,
      displayNameWOExt: fields[1] as String,
      artist: fields[2] as String,
      uri: fields[3] as String?,
      imageUri: fields[4] as Uint8List,
      timestamp: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RecentlyPlayedModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.displayNameWOExt)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.uri)
      ..writeByte(4)
      ..write(obj.imageUri)
      ..writeByte(5)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentlyPlayedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
