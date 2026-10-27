import 'package:flutter/material.dart';

import '../main.dart';
import 'admin_screen.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final isAdmin = AppScope.of(context).account?.isAdmin == true;
    final pages = <Widget>[
      const HomeScreen(),
      const SearchScreen(),
      const LibraryScreen(),
      const ProfileScreen(),
      if (isAdmin) const AdminScreen(),
    ];
    final destinations = <NavigationDestination>[
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home_rounded),
        label: 'خانه',
      ),
      const NavigationDestination(
        icon: Icon(Icons.search_rounded),
        label: 'جست‌وجو',
      ),
      const NavigationDestination(
        icon: Icon(Icons.bookmark_border_rounded),
        selectedIcon: Icon(Icons.bookmark_rounded),
        label: 'فهرست من',
      ),
      const NavigationDestination(
        icon: Icon(Icons.person_outline_rounded),
        selectedIcon: Icon(Icons.person_rounded),
        label: 'پروفایل',
      ),
      if (isAdmin)
        const NavigationDestination(
          icon: Icon(Icons.admin_panel_settings_outlined),
          selectedIcon: Icon(Icons.admin_panel_settings_rounded),
          label: 'مدیریت',
        ),
    ];
    final safeIndex = index < pages.length ? index : 0;

    return Scaffold(
      body: IndexedStack(index: safeIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: safeIndex,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: destinations,
      ),
    );
  }
}
