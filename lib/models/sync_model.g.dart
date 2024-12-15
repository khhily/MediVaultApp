// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncModelAdapter extends TypeAdapter<SyncModel> {
  @override
  final int typeId = 1;

  @override
  SyncModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncModel(
      syncUrl: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SyncModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.syncUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
