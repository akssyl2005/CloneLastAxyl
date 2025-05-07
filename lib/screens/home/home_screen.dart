import 'package:flutter/material.dart';
import 'package:complete_shop_clone/widgets/top_bar.dart';
import 'package:complete_shop_clone/widgets/home_body.dart';
import 'package:complete_shop_clone/widgets/bottom_navbar.dart';
import 'package:complete_shop_clone/widgets/search_bar_home.dart';
import '../../../cart/cart_screen.dart';
import '../../../profile/profile_screen.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeBody(),
     const Center(child: Text("", style: TextStyle(fontSize: 18))),
    const CartScreen(),
   const ProfileScreen(),
    //const Center(child: Text("Profil", style: TextStyle(fontSize: 18))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
           if (_currentIndex == 0 ) const SafeArea(child: TopBar()), // Profil en haut
           if (_currentIndex == 0 || _currentIndex == 1 ) const SearchBarHome(),// 👈 Barre de recherche qui apparit uniquement dans le home 
          Expanded(child: _screens[_currentIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}

