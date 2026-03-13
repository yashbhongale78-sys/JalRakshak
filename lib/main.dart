// lib/main.dart
// Application entry point.
// Initializes Firebase, Hive offline storage, and starts the app.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_localizations.dart';
import 'core/providers/language_provider.dart';
import 'data/models/symptom_report_model.dart';
import 'data/models/water_report_model.dart';
import 'data/services/notification_service.dart';
import 'data/repositories/sync_repository.dart';
import 'data/services/offline_storage_service.dart';
import 'data/services/firestore_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'presentation/screens/main_navigation.dart';

void main() async {
  // Ensure Flutter binding is initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();

  // Lock screen orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // ── Initialize Firebase ────────────────────────────────────
  await Firebase.initializeApp();

  // ── Initialize Hive Offline Storage ───────────────────────
  await Hive.initFlutter();

  // Register generated Hive type adapters
  Hive.registerAdapter(SymptomReportModelAdapter());
  Hive.registerAdapter(WaterReportModelAdapter());

  // Open Hive boxes (persistent local databases)
  await Hive.openBox<SymptomReportModel>(
    AppConstants.hiveBoxSymptomReports,
  );
  await Hive.openBox<WaterReportModel>(
    AppConstants.hiveBoxWaterReports,
  );

  // ── Initialize Push Notifications ─────────────────────────
  final notificationService = NotificationService();
  await notificationService.initialize();

  // ── Start Auto Sync ────────────────────────────────────────
  final syncRepo = SyncRepository(
    offlineService: OfflineStorageService(),
    firestoreService: FirestoreService(),
  );
  syncRepo.startAutoSync();

  // ── Run App ────────────────────────────────────────────────
  runApp(
    // ProviderScope wraps the whole app for Riverpod state management
    const ProviderScope(
      child: WaterborneDetectionApp(),
    ),
  );
}

/// Root application widget.
class WaterborneDetectionApp extends ConsumerWidget {
  const WaterborneDetectionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state to decide which screen to show
    final authState = ref.watch(authProvider);
    final locale = ref.watch(languageProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: authState.when(
        // Loading — show splash screen
        loading: () => const _SplashScreen(),

        // Error — show login with error
        error: (error, _) => const LoginScreen(),

        // Data — route based on login state
        data: (user) {
          if (user == null) {
            // Not logged in → Login
            return const LoginScreen();
          }

          // Logged in → Route by role
          switch (user.role) {
            case AppConstants.roleVillager:
              return const MainNavigation();  // Villager Dashboard
            case AppConstants.roleHealthWorker:
              return const MainNavigation();  // ASHA Worker Dashboard (same as villager for now)
            case AppConstants.roleGovernment:
              // TODO: Implement government dashboard in Part 2
              return const _ComingSoonScreen(role: 'Government Official');
            default:
              return const MainNavigation();
          }
        },
      ),
    );
  }
}

/// Simple Firebase connectivity demo widget kept alongside the main app flow.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waterborne Detection',
      home: Scaffold(
        appBar: AppBar(title: const Text('Firebase Connected')),
        body: const Center(child: Text('Firebase is working')),
      ),
    );
  }
}

// ─── Splash Screen ───────────────────────────────────────────────────────────

// ─── Splash Screen ───────────────────────────────────────────────────────────

class _SplashScreen extends StatefulWidget {
  const _SplashScreen();

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    _animationController.forward();

    // Auto navigate after 2.5 seconds
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        // Navigation is handled by the auth provider
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundDark,
              Color(0xFF1E293B),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Animated water drop logo
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.water_drop,
                                  size: 60,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 32),
                              // App name
                              const Text(
                                'JALARAKSHA',
                                style: TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Tagline
                              const Text(
                                'Early Warning System for Waterborne Diseases',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Protecting Communities',
                                style: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Loading bar at bottom
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _animationController.value,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Powered by AI & Blockchain',
                      style: TextStyle(
                        color: AppColors.textMuted,
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
    );
  }
}

// ─── Coming Soon Screen (for Part 2 roles) ───────────────────────────────────

class _ComingSoonScreen extends ConsumerWidget {
  final String role;

  const _ComingSoonScreen({required this.role});

  Future<void> _fixUserRole(BuildContext context, WidgetRef ref) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      // Update the user's role to villager
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({'role': 'villager'});

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Role updated! Reloading...'),
            backgroundColor: AppColors.safe,
          ),
        );
      }

      // Sign out and back in to refresh the role
      await ref.read(authProvider.notifier).signOut();
      
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(role),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).signOut(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.construction,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '$role Dashboard',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'This dashboard is being built.\nIt will be available in Part 2 of the platform.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '🔜 Coming Soon',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 32),
              // Fix Role Button
              ElevatedButton.icon(
                onPressed: () => _fixUserRole(context, ref),
                icon: const Icon(Icons.person),
                label: const Text('Switch to Villager Dashboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Click above to access the villager features',
                style: TextStyle(
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
  }
}
