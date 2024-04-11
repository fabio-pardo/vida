import 'package:flutter/material.dart';
import 'package:vida/widgets/admin/navbar.dart' show NavBar;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Screen'),
        backgroundColor: Colors.green[400],
      ),
      drawer: Drawer(
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
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 26),
          ],
        ),
      ),
      body: const Center(
        child: Text("Something will go here."),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
