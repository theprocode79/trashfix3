import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trashfix2/providers/details_provider.dart';
import 'package:trashfix2/providers/store_provider.dart';
import 'package:trashfix2/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:trashfix2/widgets/3d_globe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => StoreProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomeScreen(),
        title: "Trashfix",
      ),
    );
  }
}
