// lib/data/models/water_report_model.dart
// Data model for water contamination reports.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'water_report_model.g.dart';

/// Represents a water contamination report filed by a villager.
@HiveType(typeId: 1)
class WaterReportModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String reporterId;

  @HiveField(2)
  final String reporterName;

  @HiveField(3)
  final String village;

  @HiveField(4)
  final String district;

  @HiveField(5)
  final String state;

  @HiveField(6)
  final String waterSourceName;   // Name of the contaminated water source

  @HiveField(7)
  final List<String> issues;      // Types of contamination issues

  @HiveField(8)
  final String? photoUrl;         // Optional photo from Firebase Storage

  @HiveField(9)
  final String? description;      // Additional description

  @HiveField(10)
  final DateTime reportedAt;

  @HiveField(11)
  final bool isSynced;

  @HiveField(12)
  final String status;            // pending | under_review | resolved

  @HiveField(13)
  final double? latitude;

  @HiveField(14)
  final double? longitude;

  @HiveField(15)
  final bool isUrgent;            // Mark if needs immediate attention

  WaterReportModel({
    required this.id,
    required this.reporterId,
    required this.reporterName,
    required this.village,
    required this.district,
    required this.state,
    required this.waterSourceName,
    required this.issues,
    this.photoUrl,
    this.description,
    required this.reportedAt,
    this.isSynced = false,
    this.status = 'pending',
    this.latitude,
    this.longitude,
    this.isUrgent = false,
  });

  /// Serialize to Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reporterId': reporterId,
      'reporterName': reporterName,
      'village': village,
      'district': district,
      'state': state,
      'waterSourceName': waterSourceName,
      'issues': issues,
      'photoUrl': photoUrl,
      'description': description,
      'reportedAt': Timestamp.fromDate(reportedAt),
      'status': status,
      'isUrgent': isUrgent,
      'location': (latitude != null && longitude != null)
          ? GeoPoint(latitude!, longitude!)
          : null,
    };
  }

  /// Deserialize from Firestore
  factory WaterReportModel.fromMap(Map<String, dynamic> map) {
    GeoPoint? geo = map['location'];
    return WaterReportModel(
      id: map['id'] ?? '',
      reporterId: map['reporterId'] ?? '',
      reporterName: map['reporterName'] ?? '',
      village: map['village'] ?? '',
      district: map['district'] ?? '',
      state: map['state'] ?? '',
      waterSourceName: map['waterSourceName'] ?? '',
      issues: List<String>.from(map['issues'] ?? []),
      photoUrl: map['photoUrl'],
      description: map['description'],
      reportedAt:
          (map['reportedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isSynced: true,
      status: map['status'] ?? 'pending',
      isUrgent: map['isUrgent'] ?? false,
      latitude: geo?.latitude,
      longitude: geo?.longitude,
    );
  }

  WaterReportModel withSynced() {
    return WaterReportModel(
      id: id,
      reporterId: reporterId,
      reporterName: reporterName,
      village: village,
      district: district,
      state: state,
      waterSourceName: waterSourceName,
      issues: issues,
      photoUrl: photoUrl,
      description: description,
      reportedAt: reportedAt,
      isSynced: true,
      status: status,
      latitude: latitude,
      longitude: longitude,
      isUrgent: isUrgent,
    );
  }

  @override
  String toString() =>
      'WaterReport(id: $id, source: $waterSourceName, village: $village, '
      'synced: $isSynced)';
}
