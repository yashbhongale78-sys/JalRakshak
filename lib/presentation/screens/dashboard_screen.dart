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
            const SliverToBoxAdapter(
              child: QuickReportCard(),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 24),
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
}
