// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookMarkedMovieAdapter extends TypeAdapter<BookMarkedMovie> {
  @override
  final int typeId = 1;

  @override
  BookMarkedMovie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookMarkedMovie(
      id: fields[0] as String?,
      title: fields[1] as String?,
      year: fields[2] as String?,
      poster: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BookMarkedMovie obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.year)
      ..writeByte(3)
      ..write(obj.poster);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookMarkedMovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
