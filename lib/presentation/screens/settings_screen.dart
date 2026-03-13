// lib/presentation/screens/settings_screen.dart
// Settings screen with language selection

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/language_provider.dart';
import '../../core/localization/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(l10n.t('settings')),
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Language Section
          _buildSectionHeader(l10n.t('language')),
          _buildLanguageTile(
            context: context,
            ref: ref,
            title: l10n.t('english'),
            languageCode: 'en',
            isSelected: locale.languageCode == 'en',
          ),
          _buildLanguageTile(
            context: context,
            ref: ref,
            title: l10n.t('hindi'),
            languageCode: 'hi',
            isSelected: locale.languageCode == 'hi',
          ),
          _buildLanguageTile(
            context: context,
            ref: ref,
            title: l10n.t('marathi'),
            languageCode: 'mr',
            isSelected: locale.languageCode == 'mr',
          ),
          _buildLanguageTile(
            context: context,
            ref: ref,
            title: l10n.t('tamil'),
            languageCode: 'ta',
            isSelected: locale.languageCode == 'ta',
          ),
          _buildLanguageTile(
            context: context,
            ref: ref,
            title: l10n.t('telugu'),
            languageCode: 'te',
            isSelected: locale.languageCode == 'te',
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildLanguageTile({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required String languageCode,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.cardDark,
          width: 2,
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textLight,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontFamily: 'Poppins',
          ),
        ),
        trailing: isSelected
            ? const Icon(
                Icons.check_circle,
                color: AppColors.primary,
              )
            : null,
        onTap: () {
          ref.read(languageProvider.notifier).changeLanguage(languageCode);

          // Show restart dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: AppColors.cardDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Language Changed',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontFamily: 'Poppins',
                ),
              ),
              content: const Text(
                'Please restart the app to apply the language change.',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontFamily: 'Poppins',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
