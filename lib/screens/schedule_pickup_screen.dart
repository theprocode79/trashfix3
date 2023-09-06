import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trashfix2/models/schedule_model.dart';
import 'package:trashfix2/utils/utils.dart';
import 'package:trashfix2/widgets/custom_button.dart';

import '../providers/details_provider.dart';

class SchedulePickupScreen extends StatefulWidget {
  const SchedulePickupScreen({Key? key}) : super(key: key);

  @override
  State<SchedulePickupScreen> createState() => _SchedulePickupScreenState();
}

class _SchedulePickupScreenState extends State<SchedulePickupScreen> {
  List<String> list = <String>['7:00AM', '7:30AM', '8:00AM', '8:30AM'];
  String dropdownValue = '7:00AM';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("TrashFix"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Date: Tomorrow (${DateTime.now().add(const Duration(days: 1)).day}/${DateTime.now().add(const Duration(days: 1)).month}/${DateTime.now().add(const Duration(days: 1)).year})",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Select the time: ",
                    style: TextStyle(fontSize: 18),
                  ),
                  DropdownButton<String>(
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      value: dropdownValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: list.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      }),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: CustomButton(
                  text: "Schedule Pickup",
                  onPressed: () => storeData(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ScheduleModel scheduleModel = ScheduleModel(
      type: "Schedule",
      date: dropdownValue,
      createdAt: DateTime.now().toString(),
      phoneNumber: ap.userModel.phoneNumber,
      uid: ap.userModel.uid,
      time: dropdownValue,
      status: "Pending",
    );
    ap.saveScheduleDataToFirebase(
        context: context,
        scheduleModel: scheduleModel,
        onSuccess: () {
          showSnackBar(context, "Uploaded, see you soon!");
        });
  }
}
