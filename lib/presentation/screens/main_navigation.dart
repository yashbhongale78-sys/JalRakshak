// lib/presentation/screens/main_navigation.dart
// JALARAKSHA Main Navigation - Modern Healthcare Design

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'dashboard_screen.dart';
import 'map_screen.dart';
import 'reports_screen.dart';
import 'modern_alerts_screen.dart';
import 'more_screen.dart';

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  List<AnimationController> _tabAnimationControllers = [];
  bool _isAshaWorker = false;
  
  bool _checkIsAshaWorker() {
    final user = ref.watch(currentUserProvider);
    return user?.role == AppConstants.roleHealthWorker;
  }

  List<Widget> _getScreens() {
    if (_isAshaWorker) {
      // ASHA Worker: Home, Map, Reports, Alerts, More
      return [
        const DashboardScreen(),
        const MapScreen(),
        const ReportsScreen(),
        const ModernAlertsScreen(),
        const MoreScreen(),
      ];
    } else {
      // Villager: Home, Map, Alerts, More
      return [
        const DashboardScreen(),
        const MapScreen(),
        const ModernAlertsScreen(),
        const MoreScreen(),
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check role and initialize tab controllers
    final wasAshaWorker = _isAshaWorker;
    _isAshaWorker = _checkIsAshaWorker();
    
    // Only reinitialize if role changed
    if (wasAshaWorker != _isAshaWorker || _tabAnimationControllers.isEmpty) {
      _initializeTabControllers();
    }
  }

  void _initializeTabControllers() {
    // Dispose old controllers if any
    for (final controller in _tabAnimationControllers) {
      controller.dispose();
    }
    
    final tabCount = _isAshaWorker ? 5 : 4;
    _tabAnimationControllers = List.generate(
      tabCount,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    if (_tabAnimationControllers.isNotEmpty) {
      _tabAnimationControllers[0].forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (final controller in _tabAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_selectedIndex != index) {
      if (_selectedIndex < _tabAnimationControllers.length) {
        _tabAnimationControllers[_selectedIndex].reverse();
      }
      if (index < _tabAnimationControllers.length) {
        _tabAnimationControllers[index].forward();
      }

      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = _getScreens();
    
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 80 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildNavItems(),
        ),
      ),
    );
  }

  List<Widget> _buildNavItems() {
    if (_isAshaWorker) {
      // ASHA Worker: Home, Map, Reports, Alerts, More
      return [
        _buildNavItem(0, Icons.dashboard_outlined, Icons.dashboard, 'Home'),
        _buildNavItem(1, Icons.map_outlined, Icons.map, 'Map'),
        _buildNavItem(2, Icons.description_outlined, Icons.description, 'Reports'),
        _buildNavItem(3, Icons.notifications_outlined, Icons.notifications, 'Alerts', badgeCount: 3),
        _buildNavItem(4, Icons.menu_outlined, Icons.menu, 'More'),
      ];
    } else {
      // Villager: Home, Map, Alerts, More
      return [
        _buildNavItem(0, Icons.dashboard_outlined, Icons.dashboard, 'Home'),
        _buildNavItem(1, Icons.map_outlined, Icons.map, 'Map'),
        _buildNavItem(2, Icons.notifications_outlined, Icons.notifications, 'Alerts', badgeCount: 3),
        _buildNavItem(3, Icons.menu_outlined, Icons.menu, 'More'),
      ];
    }
  }

  Widget _buildNavItem(
    int index,
    IconData inactiveIcon,
    IconData activeIcon,
    String label, {
    int? badgeCount,
  }) {
    final isSelected = _selectedIndex == index;
    final animation = index < _tabAnimationControllers.length 
        ? _tabAnimationControllers[index]
        : _animationController;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isSelected ? activeIcon : inactiveIcon,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textMuted,
                        size: 24,
                      ),
                    ),
                    if (badgeCount != null && badgeCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.danger,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            badgeCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                  child: Text(label),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
