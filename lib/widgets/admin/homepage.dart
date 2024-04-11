import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Scaffold,
        Center,
        ElevatedButton,
        Widget,
        BuildContext,
        AppBar,
        Text;
import 'package:vida/widgets/admin/navigation_bar.dart' show NavBar;

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage Widget'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Sign out the current user
            // and navigate to the sign-in page
          },
          child: const Text('Sign Out'),
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
