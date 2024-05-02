import 'package:flutter/material.dart';
import 'package:vida/widgets/admin/homepage.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key, required this.signOutCallback});
  final VoidCallback signOutCallback;
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

  final List<Widget> _pages = [
    const AdminHomePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
      drawer: MyDrawer(widget: widget),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
    required this.widget,
  });

  final NavBar widget;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: const [
                SizedBox(
                  height: 115,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                    margin: EdgeInsets.all(0.0),
                    padding: EdgeInsets.all(0.0),
                    child: null,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              widget.signOutCallback();
            },
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }
}
