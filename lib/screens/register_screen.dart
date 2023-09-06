import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trashfix2/providers/details_provider.dart';
import 'package:trashfix2/widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = TextEditingController();
  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: phoneController.text.length));

    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 25,
            horizontal: 35,
          ),
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple.shade50,
                ),
                child: Image.asset(
                  'assets/2521468.jpg',
                  height: 300,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Add your phone number, we'll send you a verification code",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18.0),
                onChanged: ((value) {
                  setState(() {
                    phoneController.text = value;
                  });
                }),
                cursorColor: Colors.purple,
                controller: phoneController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600),
                  hintText: "Enter Phone Number",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black12)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black12)),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        showCountryPicker(
                            context: context,
                            countryListTheme: const CountryListThemeData(
                                bottomSheetHeight: 550),
                            onSelect: (value) {
                              setState(() {
                                selectedCountry = value;
                              });
                            });
                      },
                      child: Text(
                        "${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}",
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  suffixIcon: phoneController.text.length > 9
                      ? Container(
                          margin: const EdgeInsets.all(10.0),
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.green),
                          child: const Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                    text: "Login", onPressed: () => sendPhoneNumber()),
              )
            ],
          ),
        ),
      )),
    );
  }

  void sendPhoneNumber() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber");
  }
}
