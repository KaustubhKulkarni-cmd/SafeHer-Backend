import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/sos_screen.dart';
import 'screens/ai_chat_screen.dart';
import 'screens/location_screen.dart';
import 'screens/routes_screen.dart';
import 'widgets/bottom_nav_bar.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static final _pages = [
    
    const HomePage(),
    const SosScreen(),
    const AiChatScreen(),
    const LocationScreen(),
    const RoutesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, anim) =>
            FadeTransition(opacity: anim, child: child),
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        current: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
