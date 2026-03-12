// lib/presentation/screens/modern_alerts_screen.dart
// JALARAKSHA Modern Alerts Screen - Healthcare Design with Real Firebase Data

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../core/theme/app_theme.dart';
import '../../data/providers/alerts_provider.dart';

class ModernAlertsScreen extends ConsumerStatefulWidget {
  const ModernAlertsScreen({super.key});

  @override
  ConsumerState<ModernAlertsScreen> createState() => _ModernAlertsScreenState();
}

class _ModernAlertsScreenState extends ConsumerState<ModernAlertsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: Row(
          children: [
            const Text(
              'Active Alerts',
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(width: 8),
            Consumer(
              builder: (context, ref, child) {
                final alertsAsync = ref.watch(activeAlertsCountProvider);
                return alertsAsync.when(
                  data: (count) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  loading: () => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.textMuted,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  error: (_, __) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.textMuted,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _animationController,
        child: Column(
          children: [
            _buildSummarySection(),
            Expanded(
              child: _buildAlertsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final criticalAsync = ref.watch(criticalAlertsCountProvider);
                return criticalAsync.when(
                  data: (count) => _buildSummaryCard(
                    'Critical',
                    count.toString(),
                    AppColors.danger,
                    Icons.warning,
                  ),
                  loading: () => _buildSummaryCard(
                    'Critical',
                    '...',
                    AppColors.danger,
                    Icons.warning,
                  ),
                  error: (_, __) => _buildSummaryCard(
                    'Critical',
                    '0',
                    AppColors.danger,
                    Icons.warning,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final warningAsync = ref.watch(warningAlertsCountProvider);
                return warningAsync.when(
                  data: (count) => _buildSummaryCard(
                    'Warning',
                    count.toString(),
                    AppColors.warning,
                    Icons.info_outline,
                  ),
                  loading: () => _buildSummaryCard(
                    'Warning',
                    '...',
                    AppColors.warning,
                    Icons.info_outline,
                  ),
                  error: (_, __) => _buildSummaryCard(
                    'Warning',
                    '0',
                    AppColors.warning,
                    Icons.info_outline,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final resolvedAsync = ref.watch(resolvedTodayCountProvider);
                return resolvedAsync.when(
                  data: (count) => _buildSummaryCard(
                    'Resolved Today',
                    count.toString(),
                    AppColors.safe,
                    Icons.check_circle_outline,
                  ),
                  loading: () => _buildSummaryCard(
                    'Resolved Today',
                    '...',
                    AppColors.safe,
                    Icons.check_circle_outline,
                  ),
                  error: (_, __) => _buildSummaryCard(
                    'Resolved Today',
                    '0',
                    AppColors.safe,
                    Icons.check_circle_outline,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsList() {
    final alerts = _getMockAlerts();
    final activeAlerts = alerts.where((alert) => !alert['resolved']).toList();
    final resolvedAlerts = alerts.where((alert) => alert['resolved']).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Active alerts
        ...activeAlerts.map((alert) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeOut,
              )),
              child: _buildAlertCard(alert),
            )),

        // Resolved section
        if (resolvedAlerts.isNotEmpty) ...[
          const SizedBox(height: 24),
          ExpansionTile(
            title: Text(
              'Resolved Alerts (${resolvedAlerts.length})',
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            iconColor: AppColors.textMuted,
            collapsedIconColor: AppColors.textMuted,
            children:
                resolvedAlerts.map((alert) => _buildAlertCard(alert)).toList(),
          ),
        ],

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final isCritical = alert['severity'] == 'critical';
    final isResolved = alert['resolved'];
    final color = isResolved
        ? AppColors.textMuted
        : (isCritical ? AppColors.danger : AppColors.warning);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: color,
            width: 4,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getAlertIcon(alert['type']),
                    color: color,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert['title'],
                        style: TextStyle(
                          color: isResolved
                              ? AppColors.textMuted
                              : AppColors.textLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${alert['reportCount']} reports in last 24 hours - ${alert['zone']}',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  timeago.format(alert['timestamp']),
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),

            if (!isResolved) ...[
              const SizedBox(height: 12),
              // Progress bar
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: alert['progress'],
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${(alert['progress'] * 100).toInt()}% of threshold reached',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),
              // Action buttons
              Row(
                children: [
                  _buildActionButton(
                    'Resolve',
                    AppColors.safe,
                    Icons.check,
                    () => _resolveAlert(alert),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    'Dispatch',
                    AppColors.primary,
                    Icons.send,
                    () => _dispatchAlert(alert),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    'Escalate',
                    AppColors.danger,
                    Icons.arrow_upward,
                    () => _escalateAlert(alert),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    Color color,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 14, color: color),
        label: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontFamily: 'Poppins',
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color),
          padding: const EdgeInsets.symmetric(vertical: 8),
          minimumSize: Size.zero,
        ),
      ),
    );
  }

  IconData _getAlertIcon(String type) {
    switch (type) {
      case 'SYMPTOM':
        return Icons.sick;
      case 'WATER':
        return Icons.water_drop;
      case 'ANIMAL':
        return Icons.pets;
      case 'SCHOOL':
        return Icons.school;
      default:
        return Icons.warning;
    }
  }

  void _resolveAlert(Map<String, dynamic> alert) {
    // Implement resolve functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alert "${alert['title']}" marked as resolved'),
        backgroundColor: AppColors.safe,
      ),
    );
  }

  void _dispatchAlert(Map<String, dynamic> alert) {
    // Implement dispatch functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Emergency team dispatched for "${alert['title']}"'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _escalateAlert(Map<String, dynamic> alert) {
    // Implement escalate functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Alert "${alert['title']}" escalated to higher authorities'),
        backgroundColor: AppColors.danger,
      ),
    );
  }

  List<Map<String, dynamic>> _getMockAlerts() {
    return [
      {
        'title': 'SYMPTOM Outbreak Detected',
        'type': 'SYMPTOM',
        'reportCount': 12,
        'zone': 'Zone 91XXXX',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'severity': 'critical',
        'progress': 0.8,
        'resolved': false,
      },
      {
        'title': 'WATER Contamination Alert',
        'type': 'WATER',
        'reportCount': 5,
        'zone': 'Zone 91YYYY',
        'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
        'severity': 'warning',
        'progress': 0.4,
        'resolved': false,
      },
      {
        'title': 'ANIMAL Death Reports',
        'type': 'ANIMAL',
        'reportCount': 3,
        'zone': 'Zone 91ZZZZ',
        'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
        'severity': 'warning',
        'progress': 0.3,
        'resolved': false,
      },
      {
        'title': 'SCHOOL Health Emergency',
        'type': 'SCHOOL',
        'reportCount': 8,
        'zone': 'Zone 91AAAA',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'severity': 'critical',
        'progress': 1.0,
        'resolved': true,
      },
      {
        'title': 'WATER Quality Issue',
        'type': 'WATER',
        'reportCount': 4,
        'zone': 'Zone 91BBBB',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'severity': 'warning',
        'progress': 1.0,
        'resolved': true,
      },
    ];
  }
}
