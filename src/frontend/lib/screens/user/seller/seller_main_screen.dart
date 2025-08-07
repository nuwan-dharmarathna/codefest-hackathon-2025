import 'package:flutter/material.dart';
import 'package:frontend/screens/user/seller/create_advertisement_screen.dart';
import 'package:frontend/screens/user/seller/purchase_request_screen.dart';
import 'package:frontend/screens/user/seller/seller_home_screen.dart';
import 'package:frontend/screens/user/user_profile_screen.dart';
import 'package:frontend/screens/user/user_tenders_screen.dart';

class SellerMainScreen extends StatefulWidget {
  const SellerMainScreen({super.key});

  @override
  State<SellerMainScreen> createState() => _SellerMainScreenState();
}

class _SellerMainScreenState extends State<SellerMainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    SellerHomeScreen(),
    UserTendersScreen(),
    CreateAdvertisementScreen(),
    PurchaseRequestScreen(),
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
                  "assets/icons/add.png",
                  color: _selectedIndex == 2
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).brightness == Brightness.light
                      ? Colors.black54
                      : Colors.white54,
                  width: MediaQuery.of(context).size.width * 0.06,
                ),
                label: "Create",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/order.png",
                  color: _selectedIndex == 3
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).brightness == Brightness.light
                      ? Colors.black54
                      : Colors.white54,
                  width: MediaQuery.of(context).size.width * 0.06,
                ),
                label: "Requests",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/icons/user.png",
                  color: _selectedIndex == 4
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
