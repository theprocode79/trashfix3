import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/details_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.purple,
            backgroundImage: NetworkImage(ap.userModel.profilePic),
            radius: 50,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(ap.userModel.name),
          Text(ap.userModel.phoneNumber),
          Text(ap.userModel.email),
          Text(ap.userModel.address),
          Text(ap.userModel.points),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    ));
  }
}
