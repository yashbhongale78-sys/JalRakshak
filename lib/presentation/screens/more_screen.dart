// lib/presentation/screens/more_screen.dart
// JALARAKSHA More/Menu Screen - Modern Healthcare Design

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'officials_screen.dart';
import 'settings_screen.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen>
    with SingleTickerProviderStateMixin {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileSection(user),
              _buildMenuItems(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(user) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  user?.name.isNotEmpty == true
                      ? user!.name[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
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
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getRoleDisplayName(user?.role ?? ''),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${user?.village ?? ''}, ${user?.district ?? ''}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems() {
    final l10n = AppLocalizations.of(context);

    final menuItems = [
      {
        'title': l10n.t('officials_directory'),
        'subtitle': l10n.t('contact_health_officials'),
        'icon': Icons.people_outline,
        'color': AppColors.primary,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OfficialsScreen()),
          );
        },
      },
      {
        'title': l10n.t('supply_chain'),
        'subtitle': l10n.t('medical_supplies_tracking'),
        'icon': Icons.local_shipping_outlined,
        'color': AppColors.warning,
        'onTap': () {
          _showComingSoon(l10n.t('supply_chain'));
        },
      },
      {
        'title': l10n.t('analytics'),
        'subtitle': l10n.t('health_data_insights'),
        'icon': Icons.bar_chart_outlined,
        'color': AppColors.safe,
        'onTap': () {
          _showComingSoon(l10n.t('analytics'));
        },
      },
      {
        'title': l10n.t('settings'),
        'subtitle': l10n.t('app_preferences'),
        'icon': Icons.settings_outlined,
        'color': AppColors.textMuted,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          );
        },
      },
      {
        'title': l10n.t('help_support'),
        'subtitle': l10n.t('get_assistance'),
        'icon': Icons.help_outline,
        'color': AppColors.primary,
        'onTap': () {
          _showComingSoon(l10n.t('help_support'));
        },
      },
      {
        'title': l10n.t('logout'),
        'subtitle': l10n.t('sign_out_account'),
        'icon': Icons.logout,
        'color': AppColors.danger,
        'onTap': () {
          _showLogoutDialog();
        },
      },
    ];

    return Column(
      children: menuItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                index * 0.1,
                (index * 0.1) + 0.3,
                curve: Curves.easeOut,
              ),
            ),
          ),
          child: _buildMenuItem(item),
        );
      }).toList(),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: item['onTap'],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'],
                    color: item['color'],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['subtitle'],
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textMuted,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'villager':
        return 'ASHA Worker';
      case 'health_worker':
        return 'BMO';
      case 'government':
        return 'District Admin';
      default:
        return 'User';
    }
  }

  void _showComingSoon(String feature) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.construction,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.t('coming_soon'),
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          content: Text(
            l10n.t('feature_being_developed'),
            style: const TextStyle(
              color: AppColors.textMuted,
              fontFamily: 'Poppins',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n.t('ok'),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.t('logout'),
            style: const TextStyle(
              color: AppColors.textLight,
              fontFamily: 'Poppins',
            ),
          ),
          content: Text(
            l10n.t('are_you_sure_logout'),
            style: const TextStyle(
              color: AppColors.textMuted,
              fontFamily: 'Poppins',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n.t('cancel'),
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await ref.read(authProvider.notifier).signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
              ),
              child: Text(
                l10n.t('logout'),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
