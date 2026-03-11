// lib/data/models/alert_model.dart
// Data model for public health outbreak alerts.

import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents an outbreak alert issued by health workers or government officials.
class AlertModel {
  final String id;
  final String title;
  final String message;
  final String location;        // Affected area / village name
  final String district;
  final String state;
  final String severity;        // low | medium | high | critical
  final DateTime issuedAt;
  final String issuedBy;        // Name of health worker / authority
  final bool isActive;          // Whether alert is still active
  final List<String> actionItems; // What people should do

  const AlertModel({
    required this.id,
    required this.title,
    required this.message,
    required this.location,
    required this.district,
    required this.state,
    required this.severity,
    required this.issuedAt,
    required this.issuedBy,
    this.isActive = true,
    this.actionItems = const [],
  });

  /// Serialize to Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'location': location,
      'district': district,
      'state': state,
      'severity': severity,
      'issuedAt': Timestamp.fromDate(issuedAt),
      'issuedBy': issuedBy,
      'isActive': isActive,
      'actionItems': actionItems,
    };
  }

  /// Deserialize from Firestore
  factory AlertModel.fromMap(Map<String, dynamic> map) {
    return AlertModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      location: map['location'] ?? '',
      district: map['district'] ?? '',
      state: map['state'] ?? '',
      severity: map['severity'] ?? 'low',
      issuedAt: (map['issuedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      issuedBy: map['issuedBy'] ?? '',
      isActive: map['isActive'] ?? true,
      actionItems: List<String>.from(map['actionItems'] ?? []),
    );
  }

  @override
  String toString() =>
      'Alert(id: $id, title: $title, severity: $severity, location: $location)';
}
