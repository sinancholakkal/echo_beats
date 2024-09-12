// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_class_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongModelClassAdapter extends TypeAdapter<SongModelClass> {
  @override
  final int typeId = 0;

  @override
  SongModelClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongModelClass(
      id: fields[0] as int,
      displayNameWOExt: fields[1] as String,
      artist: fields[2] as String,
      uri: fields[3] as String?,
      imageUri: fields[4] as Uint8List,
      songPath: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SongModelClass obj) {
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
      ..write(obj.songPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongModelClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
