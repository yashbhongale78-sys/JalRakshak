// lib/data/models/water_report_model.g.dart
// GENERATED CODE — DO NOT MODIFY BY HAND
// Run: flutter pub run build_runner build

part of 'water_report_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WaterReportModelAdapter extends TypeAdapter<WaterReportModel> {
  @override
  final int typeId = 1;

  @override
  WaterReportModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WaterReportModel(
      id: fields[0] as String,
      reporterId: fields[1] as String,
      reporterName: fields[2] as String,
      village: fields[3] as String,
      district: fields[4] as String,
      state: fields[5] as String,
      waterSourceName: fields[6] as String,
      issues: (fields[7] as List).cast<String>(),
      photoUrl: fields[8] as String?,
      description: fields[9] as String?,
      reportedAt: fields[10] as DateTime,
      isSynced: fields[11] as bool,
      status: fields[12] as String,
      latitude: fields[13] as double?,
      longitude: fields[14] as double?,
      isUrgent: fields[15] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WaterReportModel obj) {
    writer
      ..writeByte(16)
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
      ..write(obj.waterSourceName)
      ..writeByte(7)
      ..write(obj.issues)
      ..writeByte(8)
      ..write(obj.photoUrl)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.reportedAt)
      ..writeByte(11)
      ..write(obj.isSynced)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.latitude)
      ..writeByte(14)
      ..write(obj.longitude)
      ..writeByte(15)
      ..write(obj.isUrgent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterReportModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
