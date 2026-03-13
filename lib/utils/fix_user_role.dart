// lib/utils/fix_user_role.dart
// Utility to fix user role in Firestore - Run this once to update existing users

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Updates the current user's role to 'villager' in Firestore
/// Call this function once to fix existing accounts
Future<void> fixCurrentUserRole() async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    
    if (currentUser == null) {
      print('No user is currently logged in');
      return;
    }

    final firestore = FirebaseFirestore.instance;
    
    // Update the user's role to villager
    await firestore
        .collection('users')
        .doc(currentUser.uid)
        .update({
      'role': 'villager',
    });

    print('✅ Successfully updated user role to villager');
    print('User ID: ${currentUser.uid}');
    print('Email: ${currentUser.email}');
    
  } catch (e) {
    print('❌ Error updating user role: $e');
  }
}

/// Updates ALL users in the database to 'villager' role
/// WARNING: This will change all existing users to villagers
Future<void> fixAllUsersRole() async {
  try {
    final firestore = FirebaseFirestore.instance;
    
    // Get all users
    final usersSnapshot = await firestore.collection('users').get();
    
    print('Found ${usersSnapshot.docs.length} users to update');
    
    // Update each user
    for (var doc in usersSnapshot.docs) {
      await doc.reference.update({
        'role': 'villager',
      });
      print('✅ Updated user: ${doc.id}');
    }
    
    print('✅ Successfully updated all users to villager role');
    
  } catch (e) {
    print('❌ Error updating users: $e');
  }
}
