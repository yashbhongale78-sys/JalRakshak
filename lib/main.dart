// lib/main.dart
// Application entry point.
// Initializes Firebase, Hive offline storage, and starts the app.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/models/symptom_report_model.dart';
import 'data/models/water_report_model.dart';
import 'data/services/notification_service.dart';
import 'data/repositories/sync_repository.dart';
import 'data/services/offline_storage_service.dart';
import 'data/services/firestore_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/villager/screens/villager_dashboard.dart';

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

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
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
              return const VillagerDashboard();
            case AppConstants.roleHealthWorker:
              // TODO: Implement health worker dashboard in Part 2
              return const _ComingSoonScreen(role: 'Health Worker');
            case AppConstants.roleGovernment:
              // TODO: Implement government dashboard in Part 2
              return const _ComingSoonScreen(role: 'Government Official');
            default:
              return const VillagerDashboard();
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

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.headerGradient,
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.water_drop,
                size: 80,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                'JalSuraksha',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Protecting Rural Communities',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 40),
              CircularProgressIndicator(
                color: Colors.white54,
                strokeWidth: 2,
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(role),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                ref.read(authProvider.notifier).signOut(),
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
                decoration: BoxDecoration(
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
            ],
          ),
        ),
      ),
    );
  }
}
