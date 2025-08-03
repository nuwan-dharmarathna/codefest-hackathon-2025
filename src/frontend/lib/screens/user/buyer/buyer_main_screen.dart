import 'package:flutter/material.dart';
import 'package:frontend/screens/user/buyer/buyer_favourites_screen.dart';
import 'package:frontend/screens/user/buyer/buyer_home_screen.dart';
import 'package:frontend/screens/user/user_profile_screen.dart';
import 'package:frontend/screens/user/user_tenders_screen.dart';

class BuyerMainScreen extends StatefulWidget {
  const BuyerMainScreen({super.key});

  @override
  State<BuyerMainScreen> createState() => _BuyerMainScreenState();
}

class _BuyerMainScreenState extends State<BuyerMainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    BuyerHomeScreen(),
    UserTendersScreen(),
    BuyerFavouritesScreen(),
    UserProfileScreen(),
  ];

  void _onBottomItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          border: Border(
            top: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.5), // Subtle border
              width: 1.0,
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            onTap: _onBottomItemTapped,
            currentIndex: _selectedIndex,
            showUnselectedLabels: false,
            showSelectedLabels: true,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            selectedLabelStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
            type: BottomNavigationBarType.fixed,
            elevation: 4,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/home.png",
                  color: _selectedIndex == 0
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).brightness == Brightness.light
                      ? Colors.black54
                      : Colors.white54.withOpacity(0.2),
                  width: MediaQuery.of(context).size.width * 0.06,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/tender.png",
                  color: _selectedIndex == 1
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).brightness == Brightness.light
                      ? Colors.black54
                      : Colors.white54,
                  width: MediaQuery.of(context).size.width * 0.06,
                ),
                label: "Tenders",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/heart.png",
                  color: _selectedIndex == 2
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).brightness == Brightness.light
                      ? Colors.black54
                      : Colors.white54,
                  width: MediaQuery.of(context).size.width * 0.06,
                ),
                label: "Favourites",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/user.png",
                  color: _selectedIndex == 3
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).brightness == Brightness.light
                      ? Colors.black54
                      : Colors.white54,
                  width: MediaQuery.of(context).size.width * 0.06,
                ),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
