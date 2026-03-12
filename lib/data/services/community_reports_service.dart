// lib/data/services/community_reports_service.dart
// Service for managing community disease reports with location-based aggregation

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/community_report_model.dart';

class CommunityReportsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Submit a new disease report
  Future<void> submitDiseaseReport(DiseaseReport report) async {
    try {
      // Add to reports collection
      await _firestore.collection('reports').add(report.toMap());

      // Update community aggregation
      await _updateCommunityAggregation(report);
    } catch (e) {
      throw Exception('Failed to submit report: $e');
    }
  }

  // Update community aggregation when a new report is added
  Future<void> _updateCommunityAggregation(DiseaseReport report) async {
    try {
      final locationKey =
          '${report.village}_${report.district}_${report.state}';
      final docRef =
          _firestore.collection('community_reports').doc(locationKey);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (snapshot.exists) {
          // Update existing aggregation
          final data = snapshot.data()!;
          final diseaseCounts =
              Map<String, int>.from(data['diseaseCounts'] ?? {});

          // Increment count for this disease type
          diseaseCounts[report.symptomType] =
              (diseaseCounts[report.symptomType] ?? 0) + 1;

          final totalCases =
              diseaseCounts.values.fold(0, (sum, count) => sum + count);
          final riskLevel = _calculateRiskLevel(totalCases);

          transaction.update(docRef, {
            'diseaseCounts': diseaseCounts,
            'totalCases': totalCases,
            'riskLevel': riskLevel,
            'lastUpdated': Timestamp.now(),
          });
        } else {
          // Create new aggregation
          final newData = {
            'location': report.village,
            'district': report.district,
            'state': report.state,
            'diseaseCounts': {report.symptomType: 1},
            'totalCases': 1,
            'riskLevel': 'LOW',
            'lastUpdated': Timestamp.now(),
          };
          transaction.set(docRef, newData);
        }
      });
    } catch (e) {
      // Log error but don't fail the main report submission
      print('Error updating community aggregation: $e');
    }
  }

  String _calculateRiskLevel(int totalCases) {
    if (totalCases >= 10) return 'HIGH';
    if (totalCases >= 5) return 'MEDIUM';
    return 'LOW';
  }

  // Get community reports for a specific location
  Stream<List<CommunityReportModel>> getCommunityReportsByLocation({
    String? district,
    String? state,
  }) {
    Query query = _firestore.collection('community_reports');

    if (district != null && district.isNotEmpty) {
      query = query.where('district', isEqualTo: district);
    }
    if (state != null && state.isNotEmpty) {
      query = query.where('state', isEqualTo: state);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CommunityReportModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // Get all community reports ordered by total cases
  Stream<List<CommunityReportModel>> getAllCommunityReports() {
    return _firestore
        .collection('community_reports')
        .orderBy('totalCases', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CommunityReportModel.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  // Get high-risk locations
  Stream<List<CommunityReportModel>> getHighRiskLocations() {
    return _firestore
        .collection('community_reports')
        .where('riskLevel', isEqualTo: 'HIGH')
        .orderBy('totalCases', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CommunityReportModel.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  // Get individual reports for a location
  Stream<List<DiseaseReport>> getReportsByLocation({
    required String village,
    required String district,
  }) {
    return _firestore
        .collection('reports')
        .where('village', isEqualTo: village)
        .where('district', isEqualTo: district)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return DiseaseReport.fromMap(doc.data());
      }).toList();
    });
  }

  // Get user's submitted reports
  Stream<List<DiseaseReport>> getUserReports(String userId) {
    return _firestore
        .collection('reports')
        .where('submitted_by', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return DiseaseReport.fromMap(doc.data());
      }).toList();
    });
  }
}
