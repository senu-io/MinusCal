import 'dart:ui';
import 'package:flutter/material.dart';
import 'screens/home_pantry_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/settings_screen.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = StorageService();
  await storageService.init();

  runApp(MinusCalApp(storageService: storageService));
}

class MinusCalApp extends StatelessWidget {
  final StorageService storageService;

  const MinusCalApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MinusCal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: MainNavigationContainer(storageService: storageService),
    );
  }
}

class MainNavigationContainer extends StatefulWidget {
  final StorageService storageService;

  const MainNavigationContainer({super.key, required this.storageService});

  @override
  State<MainNavigationContainer> createState() => _MainNavigationContainerState();
}

class _MainNavigationContainerState extends State<MainNavigationContainer> {
  int _currentIndex = 0;
  Key _pantryKey = UniqueKey();

  void _onPantryReset() {
    setState(() {
      _pantryKey = UniqueKey();
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomePantryScreen(
        key: _pantryKey,
        storageService: widget.storageService,
        onOpenSettings: () => setState(() => _currentIndex = 2),
      ),
      FavoritesScreen(
        storageService: widget.storageService,
      ),
      SettingsScreen(
        storageService: widget.storageService,
        onPantryReset: _onPantryReset,
      ),
    ];

    return Scaffold(
      extendBody: true, // Allows content to scroll underneath liquid glass navigation
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      // Oxfords Liquid Glass Inset Navigation Capsule
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08), // 8-14% on black ground
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(0, Icons.kitchen_outlined, Icons.kitchen, 'Kitchen'),
                    _buildNavItem(1, Icons.favorite_border, Icons.favorite, 'Saved'),
                    _buildNavItem(2, Icons.tune_outlined, Icons.tune, 'Settings'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData filledIcon, String label) {
    final isSelected = _currentIndex == index;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withValues(alpha: 0.14) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? filledIcon : outlineIcon,
                size: 20,
                color: isSelected ? AppTheme.text : AppTheme.textQuiet,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppTheme.text : AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
