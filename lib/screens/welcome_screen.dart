import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trashfix2/providers/details_provider.dart';
import 'package:trashfix2/widgets/bottom_nav_bar.dart';
import 'package:trashfix2/screens/register_screen.dart';
import 'package:trashfix2/widgets/custom_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/2521468.jpg',
                  height: 300,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Welcome to Trashfix!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Let's get started",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton(
                        text: "Get Started",
                        onPressed: () async {
                          if (ap.isSignedIn == true) {
                            await ap.getDataFromSp().whenComplete(
                                  () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                  ),
                                );
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()));
                          }
                        }))
              ]),
        ),
      ),
    ));
  }
}
// Users should not come to this screen if they're already logged in