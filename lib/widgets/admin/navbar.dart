import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});
  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  static const IconData mealIcon =
      IconData(0xe532, fontFamily: 'MaterialIcons');

  static const IconData menuBookIcon =
      IconData(0xe3dd, fontFamily: 'MaterialIcons');

  static const IconData ordersIcon =
      IconData(0xe1bd, fontFamily: 'MaterialIcons');
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on the selected index
    switch (index) {
      case 0:
        // Navigate to home screen
        break;
      case 1:
        // Navigate to business screen
        break;
      case 2:
        // Navigate to school screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(mealIcon),
          label: 'Meals',
        ),
        BottomNavigationBarItem(
          icon: Icon(menuBookIcon),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(ordersIcon),
          label: 'Orders',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }
}
