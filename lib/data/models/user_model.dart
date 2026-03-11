// lib/data/models/user_model.dart
// Data model representing an authenticated user of the platform.

import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a registered user in the system.
/// Roles: villager | health_worker | government
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role;           // villager | health_worker | government
  final String village;        // Home village name
  final String district;       // District in NE India
  final String state;          // State in NE India
  final DateTime createdAt;
  final bool isActive;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.village,
    required this.district,
    required this.state,
    required this.createdAt,
    this.isActive = true,
  });

  /// Convert to Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'village': village,
      'district': district,
      'state': state,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
    };
  }

  /// Create from Firestore document snapshot
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'villager',
      village: map['village'] ?? '',
      district: map['district'] ?? '',
      state: map['state'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: map['isActive'] ?? true,
    );
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? name,
    String? phone,
    String? village,
    String? district,
    String? state,
    bool? isActive,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      role: role,
      village: village ?? this.village,
      district: district ?? this.district,
      state: state ?? this.state,
      createdAt: createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Check if user is a villager
  bool get isVillager => role == 'villager';
  bool get isHealthWorker => role == 'health_worker';
  bool get isGovernment => role == 'government';

  @override
  String toString() =>
      'UserModel(uid: $uid, name: $name, role: $role, village: $village)';
}
