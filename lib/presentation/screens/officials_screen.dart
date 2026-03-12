// lib/presentation/screens/officials_screen.dart
// JALARAKSHA Officials Directory - Modern Healthcare Design

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';

class OfficialsScreen extends ConsumerStatefulWidget {
  const OfficialsScreen({super.key});

  @override
  ConsumerState<OfficialsScreen> createState() => _OfficialsScreenState();
}

class _OfficialsScreenState extends ConsumerState<OfficialsScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  String _selectedRole = 'All';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: const Text(
          'Health Officials',
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _animationController,
        child: Column(
          children: [
            _buildSearchSection(),
            Expanded(
              child: _buildOfficialsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          color: AppColors.textLight,
          fontFamily: 'Poppins',
        ),
        decoration: InputDecoration(
          hintText: 'Search officials...',
          hintStyle: const TextStyle(
            color: AppColors.textMuted,
            fontFamily: 'Poppins',
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textMuted,
          ),
          filled: true,
          fillColor: AppColors.cardDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          // Implement search functionality
        },
      ),
    );
  }

  Widget _buildOfficialsList() {
    final officials = _getMockOfficials();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: officials.length,
      itemBuilder: (context, index) {
        final official = officials[index];
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              index * 0.1,
              (index * 0.1) + 0.3,
              curve: Curves.easeOut,
            ),
          )),
          child: _buildOfficialCard(official),
        );
      },
    );
  }

  Widget _buildOfficialCard(Map<String, dynamic> official) {
    final roleColor = _getRoleColor(official['role']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: roleColor.withValues(alpha: 0.2),
            child: Text(
              _getInitials(official['name']),
              style: TextStyle(
                color: roleColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  official['name'],
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: roleColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    official['role'],
                    style: TextStyle(
                      color: roleColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  official['district'],
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.phone,
                  color: AppColors.safe,
                  size: 20,
                ),
                onPressed: () => _callOfficial(official),
              ),
              IconButton(
                icon: const Icon(
                  Icons.message,
                  color: AppColors.primary,
                  size: 20,
                ),
                onPressed: () => _messageOfficial(official),
              ),
              IconButton(
                icon: const Icon(
                  Icons.notification_important,
                  color: AppColors.warning,
                  size: 20,
                ),
                onPressed: () => _alertOfficial(official),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'O';
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'ASHA Worker':
        return AppColors.primary;
      case 'BMO':
        return AppColors.warning;
      case 'District Admin':
        return AppColors.danger;
      default:
        return AppColors.textMuted;
    }
  }

  void _callOfficial(Map<String, dynamic> official) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${official['name']}...'),
        backgroundColor: AppColors.safe,
      ),
    );
  }

  void _messageOfficial(Map<String, dynamic> official) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Messaging ${official['name']}...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _alertOfficial(Map<String, dynamic> official) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: Text(
          'Send Alert',
          style: const TextStyle(
            color: AppColors.textLight,
            fontFamily: 'Poppins',
          ),
        ),
        content: Text(
          'Send emergency alert to ${official['name']}?',
          style: const TextStyle(
            color: AppColors.textMuted,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textMuted,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Alert sent to ${official['name']}'),
                  backgroundColor: AppColors.warning,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
            ),
            child: const Text(
              'Send Alert',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMockOfficials() {
    return [
      {
        'name': 'Dr. Priya Sharma',
        'role': 'BMO',
        'phone': '+91 98765 43210',
        'email': 'priya.sharma@health.gov.in',
        'district': 'Jorhat District',
      },
      {
        'name': 'Ritu Devi',
        'role': 'ASHA Worker',
        'phone': '+91 98765 43211',
        'email': 'ritu.devi@asha.gov.in',
        'district': 'Majuli District',
      },
      {
        'name': 'Dr. Rajesh Kumar',
        'role': 'District Admin',
        'phone': '+91 98765 43212',
        'email': 'rajesh.kumar@admin.gov.in',
        'district': 'Dibrugarh District',
      },
      {
        'name': 'Sunita Gogoi',
        'role': 'ASHA Worker',
        'phone': '+91 98765 43213',
        'email': 'sunita.gogoi@asha.gov.in',
        'district': 'Sonitpur District',
      },
      {
        'name': 'Dr. Amit Borah',
        'role': 'BMO',
        'phone': '+91 98765 43214',
        'email': 'amit.borah@health.gov.in',
        'district': 'Cachar District',
      },
    ];
  }
}
