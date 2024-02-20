// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annotiation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnnotationModelAdapter extends TypeAdapter<AnnotationModel> {
  @override
  final int typeId = 1;

  @override
  AnnotationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnnotationModel()..annotation = fields[0] as Annotation;
  }

  @override
  void write(BinaryWriter writer, AnnotationModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.annotation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnnotationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
