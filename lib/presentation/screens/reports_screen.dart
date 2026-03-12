// lib/presentation/screens/reports_screen.dart
// JALARAKSHA Reports Screen - Modern Healthcare Design with Real Firebase Data

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../core/theme/app_theme.dart';
import '../../data/providers/reports_provider.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
        title: Row(
          children: [
            const Text(
              'Community Reports',
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
                final reportsAsync = ref.watch(reportsCountProvider);
                return reportsAsync.when(
                  data: (count) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
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
            _buildFilterSection(),
            Expanded(
              child: _buildReportsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            style: const TextStyle(
              color: AppColors.textLight,
              fontFamily: 'Poppins',
            ),
            decoration: InputDecoration(
              hintText: 'Search reports...',
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
          const SizedBox(height: 16),
          // Filter chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('SYMPTOM'),
                _buildFilterChip('WATER'),
                _buildFilterChip('ANIMAL'),
                _buildFilterChip('SCHOOL'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;
    Color chipColor;

    switch (filter) {
      case 'SYMPTOM':
        chipColor = AppColors.danger;
        break;
      case 'WATER':
        chipColor = AppColors.primary;
        break;
      case 'ANIMAL':
        chipColor = AppColors.warning;
        break;
      case 'SCHOOL':
        chipColor = AppColors.safe;
        break;
      default:
        chipColor = AppColors.textMuted;
    }

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          filter,
          style: TextStyle(
            color: isSelected ? Colors.white : chipColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = filter;
          });
        },
        backgroundColor: AppColors.cardDark,
        selectedColor: chipColor,
        checkmarkColor: Colors.white,
        side: BorderSide(
          color: isSelected ? chipColor : chipColor.withValues(alpha: 0.3),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildReportsList() {
    return Consumer(
      builder: (context, ref, child) {
        final reportsAsync = ref.watch(allReportsStreamProvider);

        return reportsAsync.when(
          data: (reports) {
            if (reports.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No reports found',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              );
            }

            // Filter reports based on selected filter
            final filteredReports = _selectedFilter == 'All'
                ? reports
                : reports
                    .where((report) => report['intent'] == _selectedFilter)
                    .toList();

            return RefreshIndicator(
              onRefresh: () async {
                // Refresh is handled automatically by the stream
                await Future.delayed(const Duration(seconds: 1));
              },
              backgroundColor: AppColors.cardDark,
              color: AppColors.primary,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredReports.length,
                itemBuilder: (context, index) {
                  final report = filteredReports[index];
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
                    child: _buildReportCard(report),
                  );
                },
              ),
            );
          },
          loading: () => ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) => _buildLoadingCard(),
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.danger,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading reports',
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingCard() {
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
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Spacer(),
              Container(
                width: 80,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.textMuted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 200,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.textMuted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    final intentColor = _getIntentColor(report['intent']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: intentColor,
            width: 4,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Navigate to report details
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: intentColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        report['intent'],
                        style: TextStyle(
                          color: intentColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      timeago.format(report['timestamp']),
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        report['language'],
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Phone number
                Text(
                  'Phone: ${report['phone']}',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                // Message
                Text(
                  report['message'],
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                // Footer row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(report['status'])
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        report['status'],
                        style: TextStyle(
                          color: _getStatusColor(report['status']),
                          fontSize: 10,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.textMuted,
                        size: 16,
                      ),
                      onPressed: () {
                        // Navigate to report details
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getIntentColor(String intent) {
    switch (intent) {
      case 'SYMPTOM':
        return AppColors.danger;
      case 'WATER':
        return AppColors.primary;
      case 'ANIMAL':
        return AppColors.warning;
      case 'SCHOOL':
        return AppColors.safe;
      default:
        return AppColors.textMuted;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return AppColors.safe;
      case 'Pending':
        return AppColors.warning;
      case 'Resolved':
        return AppColors.textMuted;
      default:
        return AppColors.textMuted;
    }
  }

  List<Map<String, dynamic>> _getMockReports() {
    return [
      {
        'intent': 'SYMPTOM',
        'phone': '91XXXX****',
        'message':
            'Multiple people in our village are experiencing fever, diarrhea, and vomiting. Started 2 days ago after drinking from the community well.',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
        'language': 'AS',
        'status': 'Active',
      },
      {
        'intent': 'WATER',
        'phone': '91YYYY****',
        'message':
            'The water from our tube well has turned brown and smells bad. Many families are affected.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'language': 'HI',
        'status': 'Active',
      },
      {
        'intent': 'ANIMAL',
        'phone': '91ZZZZ****',
        'message':
            'Dead fish found floating in the village pond. Water looks contaminated.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
        'language': 'EN',
        'status': 'Pending',
      },
      {
        'intent': 'SCHOOL',
        'phone': '91AAAA****',
        'message':
            'Many children in our school are absent due to stomach problems. Need immediate attention.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 8)),
        'language': 'AS',
        'status': 'Active',
      },
      {
        'intent': 'SYMPTOM',
        'phone': '91BBBB****',
        'message':
            'Elderly person showing severe dehydration symptoms. Needs medical help urgently.',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'language': 'HI',
        'status': 'Resolved',
      },
    ];
  }
}
