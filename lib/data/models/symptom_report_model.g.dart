// lib/data/models/symptom_report_model.g.dart
// GENERATED CODE — DO NOT MODIFY BY HAND
// Run: flutter pub run build_runner build

part of 'symptom_report_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SymptomReportModelAdapter extends TypeAdapter<SymptomReportModel> {
  @override
  final int typeId = 0;

  @override
  SymptomReportModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SymptomReportModel(
      id: fields[0] as String,
      reporterId: fields[1] as String,
      reporterName: fields[2] as String,
      village: fields[3] as String,
      district: fields[4] as String,
      state: fields[5] as String,
      symptoms: (fields[6] as List).cast<String>(),
      affectedCount: fields[7] as int,
      photoUrl: fields[8] as String?,
      additionalNotes: fields[9] as String?,
      reportedAt: fields[10] as DateTime,
      isSynced: fields[11] as bool,
      status: fields[12] as String,
      latitude: fields[13] as double?,
      longitude: fields[14] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, SymptomReportModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.reporterId)
      ..writeByte(2)
      ..write(obj.reporterName)
      ..writeByte(3)
      ..write(obj.village)
      ..writeByte(4)
      ..write(obj.district)
      ..writeByte(5)
      ..write(obj.state)
      ..writeByte(6)
      ..write(obj.symptoms)
      ..writeByte(7)
      ..write(obj.affectedCount)
      ..writeByte(8)
      ..write(obj.photoUrl)
      ..writeByte(9)
      ..write(obj.additionalNotes)
      ..writeByte(10)
      ..write(obj.reportedAt)
      ..writeByte(11)
      ..write(obj.isSynced)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.latitude)
      ..writeByte(14)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SymptomReportModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
