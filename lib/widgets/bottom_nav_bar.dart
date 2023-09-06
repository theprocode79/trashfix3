import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trashfix2/screens/home_screen.dart';
import 'package:trashfix2/screens/profile%20screens/profile_screen.dart';
import 'package:trashfix2/screens/shop_screen.dart';
import 'package:trashfix2/screens/welcome_screen.dart';

import '../providers/details_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int myIndex = 0;
  List<Widget> widgetList = [
    const BaseHomeScreen(),
    ShopScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: IndexedStack(
        index: myIndex,
        children: widgetList,
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
          currentIndex: myIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: "Shop"),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ]),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("TrashFix"),
        actions: [
          IconButton(
              onPressed: () {
                ap.userSignOut().then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen())));
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
    );
  }
}
