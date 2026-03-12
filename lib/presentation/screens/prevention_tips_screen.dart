// lib/presentation/screens/prevention_tips_screen.dart
// Displays health prevention tips for villagers.

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class PreventionTipsScreen extends StatelessWidget {
  const PreventionTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const tips = AppConstants.preventionTips;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prevention Tips'),
        backgroundColor: AppColors.secondary,
      ),
      body: CustomScrollView(
        slivers: [
          // Header banner
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.secondary, AppColors.secondaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.health_and_safety,
                      size: 48, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Stay Safe & Healthy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          'Follow these tips to prevent\nwater-borne diseases',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tips list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final tip = tips[index];
                  return _TipCard(
                    number: index + 1,
                    emoji: tip['icon']!,
                    title: tip['title']!,
                    description: tip['description']!,
                  );
                },
                childCount: tips.length,
              ),
            ),
          ),

          // Important notice at bottom
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.alertContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.alert.withOpacity(0.25)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.emergency, color: AppColors.alert),
                        SizedBox(width: 8),
                        Text(
                          'If symptoms appear:',
                          style: TextStyle(
                            color: AppColors.alert,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Seek medical help immediately. Give ORS to prevent '
                      'dehydration. Report using this app. Do NOT ignore symptoms.',
                      style: TextStyle(
                        color: AppColors.alert,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '📞 National Health Helpline: 104',
                      style: TextStyle(
                        color: AppColors.alert,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}

// ─── Tip Card Widget ─────────────────────────────────────────────────────────

class _TipCard extends StatefulWidget {
  final int number;
  final String emoji;
  final String title;
  final String description;

  const _TipCard({
    required this.number,
    required this.emoji,
    required this.title,
    required this.description,
  });

  @override
  State<_TipCard> createState() => _TipCardState();
}

class _TipCardState extends State<_TipCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Number badge
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${widget.number}',
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.emoji,
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
                if (_expanded) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: 12),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontFamily: 'Poppins',
                      height: 1.6,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
