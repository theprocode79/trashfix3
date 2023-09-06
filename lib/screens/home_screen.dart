import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trashfix2/screens/history_screen.dart';
import 'package:trashfix2/screens/leaderboard_screen.dart';
import 'package:trashfix2/screens/schedule_pickup_screen.dart';
import 'package:trashfix2/widgets/3d_globe.dart';

import '../providers/details_provider.dart';
import '../widgets/custom_button.dart';

class BaseHomeScreen extends StatefulWidget {
  const BaseHomeScreen({Key? key}) : super(key: key);

  @override
  State<BaseHomeScreen> createState() => _BaseHomeScreenState();
}

class _BaseHomeScreenState extends State<BaseHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.getStoreDataFromFirestore();
    return Scaffold(
      body: Align(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  backgroundColor: Colors.purple,
                  backgroundImage: NetworkImage(ap.userModel.profilePic),
                  radius: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Hi ${ap.userModel.name}!',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your Contribution: ${ap.userModel.points}",
                  style: const TextStyle(fontSize: 24),
                ),
                IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 400,
                width: double.infinity,
                child: Planet(
                  interative: true,
                )),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              child: CustomButton(
                  text: "Schedule a Pick-up",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SchedulePickupScreen(),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 20,
            ),

            // Row(
            //   children: [
            //     const Text("Learn how to redeem"),
            //     IconButton(
            //         onPressed: () {},
            //         icon: const Icon(
            //           Icons.info,
            //           size: 20,
            //         )),
            //   ],
            // ),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.8,
            //   height: 50,
            //   child: CustomButton(
            //       text: "Leaderboard",
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => const LeaderboardScreen(),
            //           ),
            //         );
            //       }),
            // ),
          ],
        ),
      ),
    );
  }
}

/*
Schedule Pickup button - done
Details of the customer 
Leaderboard - coming soon
all order history
take to whatsapp - directly chat with the whatsapp business account
*/