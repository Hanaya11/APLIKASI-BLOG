import 'package:flutter/material.dart';
import 'package:frontend/create.dart';
import 'package:frontend/jelajah.dart';
import 'package:frontend/profile.dart';
import 'package:frontend/save.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'homePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  // Halaman sementara
  Widget belumTersedia(String namaHalaman) {
    return Center(
      child: Text(
        '$namaHalaman belum tersedia',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6B1F2A),
        ),
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      const HomePage(),

      // Jelajah
      const JelajahPage(),

      // Tulis
      const CreatePage(),

      // Tersimpan
      const SavePage(),

      // Profil
      const ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_rounded),
        title: 'Beranda',
        activeColorPrimary: const Color(0xFF6B1F2A),
        inactiveColorPrimary: const Color(0xFF9A8580),
      ),

      PersistentBottomNavBarItem(
        icon: const Icon(Icons.explore_outlined),
        title: 'Jelajah',
        activeColorPrimary: const Color(0xFF6B1F2A),
        inactiveColorPrimary: const Color(0xFF9A8580),
      ),

      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.edit_rounded,
          color: Colors.white,
        ),
        title: 'Tulis',
        activeColorPrimary: const Color(0xFF6B1F2A),
        inactiveColorPrimary: const Color(0xFF9A8580),
      ),

      PersistentBottomNavBarItem(
        icon: const Icon(Icons.bookmark_border_rounded),
        title: 'Tersimpan',
        activeColorPrimary: const Color(0xFF6B1F2A),
        inactiveColorPrimary: const Color(0xFF9A8580),
      ),

      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_outline_rounded),
        title: 'Profil',
        activeColorPrimary: const Color(0xFF6B1F2A),
        inactiveColorPrimary: const Color(0xFF9A8580),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),

      navBarStyle: NavBarStyle.style16,

      margin: const EdgeInsets.all(0),

      padding: const EdgeInsets.only(bottom: 0),

      // WARNA NAVBAR
      backgroundColor: const Color(0xFFFFFDF8),

      decoration: const NavBarDecoration(
        borderRadius: BorderRadius.zero,

        // BACKGROUND DI BELAKANG NAVBAR
        colorBehindNavBar: Color(0xFFFFF8ED),
      ),
    );
  }
}