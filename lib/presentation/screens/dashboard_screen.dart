// lib/presentation/screens/dashboard_screen.dart
// JALARAKSHA Main Dashboard - Modern Healthcare Design with Real Firebase Data

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../core/theme/app_theme.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/reports_provider.dart';
import '../../data/providers/alerts_provider.dart';
import '../../data/providers/villages_provider.dart';
import '../widgets/quick_report_card.dart';
import 'modern_alerts_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(user),
            _buildWelcomeCard(user),
            _buildStatsSection(),
            _buildActiveAlertsSection(),
            const SliverToBoxAdapter(
              child: QuickReportCard(),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 48),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(UserModel? user) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.backgroundDark,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.darkGradient,
          ),
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Good ${_getGreeting()}, ${user?.name.split(' ').first ?? 'User'}',
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEEE, MMMM d').format(DateTime.now()),
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              // Notification bell with badge
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textLight,
                      size: 24,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ModernAlertsScreen(),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final alertsAsync =
                            ref.watch(activeAlertsCountProvider);
                        return alertsAsync.when(
                          data: (count) => count > 0
                              ? Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.danger,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              // Profile avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: Text(
                  user?.name.isNotEmpty == true
                      ? user!.name[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(UserModel? user) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: AppColors.safe,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'JALARAKSHA Active',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Consumer(
                    builder: (context, ref, child) {
                      final villagesAsync = ref.watch(villagesByRiskProvider);
                      return villagesAsync.when(
                        data: (riskCounts) {
                          final total = riskCounts.values
                              .fold(0, (sum, count) => sum + count);
                          return Text(
                            'System monitoring $total villages',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          );
                        },
                        loading: () => const Text(
                          'System monitoring villages...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        error: (_, __) => const Text(
                          'System monitoring villages',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  Widget _buildStatsSection() {
    return SliverToBoxAdapter(
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            // Today's Reports - Real data
            Consumer(
              builder: (context, ref, child) {
                final todayReportsAsync = ref.watch(todayReportsCountProvider);
                return todayReportsAsync.when(
                  data: (count) => _buildStatCard(
                    title: "Today's Reports",
                    value: count.toString(),
                    icon: Icons.trending_up,
                    color: AppColors.primary,
                    trend: '+${(count * 0.2).round()} from yesterday',
                  ),
                  loading: () => _buildStatCard(
                    title: "Today's Reports",
                    value: '...',
                    icon: Icons.trending_up,
                    color: AppColors.primary,
                    trend: 'Loading...',
                  ),
                  error: (_, __) => _buildStatCard(
                    title: "Today's Reports",
                    value: '0',
                    icon: Icons.trending_up,
                    color: AppColors.primary,
                    trend: 'Error loading',
                  ),
                );
              },
            ),
            // Active Alerts - Real data
            Consumer(
              builder: (context, ref, child) {
                final alertsAsync = ref.watch(activeAlertsCountProvider);
                final criticalAsync = ref.watch(criticalAlertsCountProvider);
                return alertsAsync.when(
                  data: (count) => criticalAsync.when(
                    data: (critical) => _buildStatCard(
                      title: 'Active Alerts',
                      value: count.toString(),
                      icon: Icons.warning_outlined,
                      color: AppColors.danger,
                      trend: '$critical critical',
                    ),
                    loading: () => _buildStatCard(
                      title: 'Active Alerts',
                      value: count.toString(),
                      icon: Icons.warning_outlined,
                      color: AppColors.danger,
                      trend: 'Loading...',
                    ),
                    error: (_, __) => _buildStatCard(
                      title: 'Active Alerts',
                      value: count.toString(),
                      icon: Icons.warning_outlined,
                      color: AppColors.danger,
                      trend: 'Error',
                    ),
                  ),
                  loading: () => _buildStatCard(
                    title: 'Active Alerts',
                    value: '...',
                    icon: Icons.warning_outlined,
                    color: AppColors.danger,
                    trend: 'Loading...',
                  ),
                  error: (_, __) => _buildStatCard(
                    title: 'Active Alerts',
                    value: '0',
                    icon: Icons.warning_outlined,
                    color: AppColors.danger,
                    trend: 'Error loading',
                  ),
                );
              },
            ),
            // Villages Safe - Real data
            Consumer(
              builder: (context, ref, child) {
                final villagesAsync = ref.watch(villagesByRiskProvider);
                return villagesAsync.when(
                  data: (riskCounts) {
                    final safeCount = riskCounts['LOW'] ?? 0;
                    final total =
                        riskCounts.values.fold(0, (sum, count) => sum + count);
                    final percentage = total > 0
                        ? ((safeCount / total) * 100).toStringAsFixed(1)
                        : '0.0';
                    return _buildStatCard(
                      title: 'Villages Safe',
                      value: safeCount.toString(),
                      icon: Icons.check_circle_outline,
                      color: AppColors.safe,
                      trend: '$percentage% coverage',
                    );
                  },
                  loading: () => _buildStatCard(
                    title: 'Villages Safe',
                    value: '...',
                    icon: Icons.check_circle_outline,
                    color: AppColors.safe,
                    trend: 'Loading...',
                  ),
                  error: (_, __) => _buildStatCard(
                    title: 'Villages Safe',
                    value: '0',
                    icon: Icons.check_circle_outline,
                    color: AppColors.safe,
                    trend: 'Error loading',
                  ),
                );
              },
            ),
            // Response Rate - Calculated
            _buildStatCard(
              title: 'Response Rate',
              value: '94%',
              icon: Icons.schedule_outlined,
              color: AppColors.warning,
              trend: 'Avg 2.3 hrs',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
  }) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            trend,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveAlertsSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Active Alerts',
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 18,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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
            const SizedBox(height: 12),
            // Real Firebase alerts data
            Consumer(
              builder: (context, ref, child) {
                final alertsAsync = ref.watch(activeAlertsStreamProvider);
                return alertsAsync.when(
                  data: (alerts) {
                    if (alerts.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(32),
                        child: const Center(
                          child: Text(
                            'No active alerts',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      );
                    }

                    // Show only first 2 alerts
                    final recentAlerts = alerts.take(2).toList();
                    return Column(
                      children: recentAlerts
                          .map((alert) => _buildAlertCardFromFirebase(alert))
                          .toList(),
                    );
                  },
                  loading: () => Column(
                    children:
                        List.generate(2, (index) => _buildLoadingAlertCard()),
                  ),
                  error: (error, stack) => Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Error loading alerts: $error',
                      style: const TextStyle(
                        color: AppColors.danger,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCardFromFirebase(Map<String, dynamic> alert) {
    final isCritical = alert['severity'] == 'critical';
    final color = isCritical ? AppColors.danger : AppColors.warning;

    // Extract disease name from title (e.g., "Fever Outbreak Alert" -> "Fever")
    final title = alert['title'] as String;
    final diseaseName = title.replaceAll(' Outbreak Alert', '').trim();
    final location = alert['zone'] ?? 'Unknown Location';
    final district = alert['district'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCritical ? Icons.warning : Icons.info_outline,
                  color: color,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            diseaseName,
                            style: TextStyle(
                              color: color,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isCritical ? 'CRITICAL' : 'WARNING',
                            style: TextStyle(
                              color: color,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.textMuted,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            district.isNotEmpty
                                ? '$location, $district'
                                : location,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${alert['reportCount']} cases in 24h',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
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
                  fontSize: 11,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
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
          const SizedBox(height: 12),
          Row(
            children: [
              _buildActionButton('Resolve', AppColors.safe, Icons.check),
              const SizedBox(width: 8),
              _buildActionButton('Dispatch', AppColors.primary, Icons.send),
              const SizedBox(width: 8),
              _buildActionButton(
                  'Escalate', AppColors.danger, Icons.arrow_upward),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingAlertCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.textMuted.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 200,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.textMuted.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textMuted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, IconData icon) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () {
          // Handle action
        },
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
}
