// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_definition.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoDefinitionAdapter extends TypeAdapter<TodoDefinition> {
  @override
  final int typeId = 1;

  @override
  TodoDefinition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoDefinition(
      type: fields[0] as String,
      style: fields[1] as String,
      color: fields[2] as String,
      action: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TodoDefinition obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.style)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.action);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoDefinitionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
