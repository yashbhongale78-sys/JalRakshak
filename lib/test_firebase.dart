// lib/test_firebase.dart
// Simple Firebase connection test

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  String _status = 'Testing Firebase connection...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _testFirebaseConnection();
  }

  Future<void> _testFirebaseConnection() async {
    try {
      // Test 1: Try to read from reports collection
      final reportsSnapshot = await FirebaseFirestore.instance
          .collection('reports')
          .limit(1)
          .get()
          .timeout(const Duration(seconds: 10));

      setState(() {
        _status =
            'Firebase connected! Found ${reportsSnapshot.docs.length} reports';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Firebase Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Test'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Icon(
                  _status.contains('Error') ? Icons.error : Icons.check_circle,
                  size: 64,
                  color: _status.contains('Error') ? Colors.red : Colors.green,
                ),
              const SizedBox(height: 16),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _testFirebaseConnection,
                child: const Text('Test Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
