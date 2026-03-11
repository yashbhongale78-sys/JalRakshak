// lib/data/services/storage_service.dart
// Manages file uploads to Firebase Storage.

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

/// Handles photo uploads to Firebase Storage.
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload a symptom report photo to Firebase Storage.
  /// Returns the download URL.
  Future<String> uploadSymptomPhoto({
    required File imageFile,
    required String reportId,
    required String userId,
  }) async {
    return _uploadFile(
      file: imageFile,
      path: 'symptom_reports/$userId/$reportId/${p.basename(imageFile.path)}',
    );
  }

  /// Upload a water contamination photo.
  /// Returns the download URL.
  Future<String> uploadWaterPhoto({
    required File imageFile,
    required String reportId,
    required String userId,
  }) async {
    return _uploadFile(
      file: imageFile,
      path: 'water_reports/$userId/$reportId/${p.basename(imageFile.path)}',
    );
  }

  /// Internal upload helper — streams progress and returns URL.
  Future<String> _uploadFile({
    required File file,
    required String path,
  }) async {
    try {
      final ref = _storage.ref().child(path);

      final uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'uploadedAt': DateTime.now().toIso8601String()},
        ),
      );

      // Wait for upload completion
      final snapshot = await uploadTask;

      // Get public download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw Exception('Photo upload failed: ${e.message}');
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }

  /// Delete a file from Storage (for cleanup).
  Future<void> deleteFile(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (_) {
      // Silently fail — file may already be deleted
    }
  }
}
