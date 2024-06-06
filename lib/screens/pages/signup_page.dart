// package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:email_validator/email_validator.dart';

//file imports
import '../../providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TimeOfDay selectedTime = TimeOfDay.now();
  String countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  String address = "";
  String displayName = "";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  final signUpFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    birthDateController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    final firstName = Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextFormField(
            controller: firstNameController,
            decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(Icons.person_rounded)),
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                hintText: "First Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter first name';
              }
              // } else {
              //   bool isValid = EmailValidator.validate(value);
              //   if (!isValid) {
              //     return 'Email is not valid';
              //   }
              // }
              return null;
            }));

    final lastName = Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextFormField(
            controller: lastNameController,
            decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(
                      Icons.person_rounded,
                    )),
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                hintText: "Last Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter last name';
              }
              // } else {
              //   bool isValid = EmailValidator.validate(value);
              //   if (!isValid) {
              //     return 'Email is not valid';
              //   }
              // }
              return null;
            }));

    final email = Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(Icons.email_rounded)),
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                hintText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              } else {
                bool isValid = EmailValidator.validate(value);
                if (!isValid) {
                  return 'Please enter a valid email Address';
                }
              }
              return null;
            }));

    final password = Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(Icons.password_rounded)),
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                hintText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              // else {
              //   bool isValid = EmailValidator.validate(value);
              //   if (!isValid) {
              //     return 'Please enter a valid email Address';
              //   }
              // }
              return null;
            }));

    final birthDate = Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextFormField(
            controller: birthDateController,
            decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(Icons.calendar_today_rounded)),
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                hintText: "Birthdate",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2101));

              if (pickedDate != null) {
                print(pickedDate);
                String formattedDate =
                    DateFormat.yMMMMd('en_US').format(pickedDate);
                print(formattedDate);

                setState(() {
                  birthDateController.text = formattedDate.toString();
                });
              } else {
                print("Date is not selected");
              }
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter birthdate';
              }
              // } else {
              //   bool isValid = EmailValidator.validate(value);
              //   if (!isValid) {
              //     return 'Email is not valid';
              //   }
              // }
              return null;
            }));

    final location = Padding(
        padding: const EdgeInsets.only(top: 10),
        child: CSCPicker(
            dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(color: Colors.black54, width: 1)),
            disabledDropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade300,
                border: Border.all(color: Colors.black54, width: 1)),
            selectedItemStyle:
                const TextStyle(color: Colors.black54, fontSize: 16),
            showCities: false,
            flagState: CountryFlag.DISABLE,
            onCountryChanged: (value) {
              setState(() {
                countryValue = value;
              });
            },
            onStateChanged: (value) {
              setState(() {
                stateValue = value;
              });
            },
            onCityChanged: (value) {
              setState(() {
                cityValue = value;
              });
            }));

    final userName = Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextFormField(
            controller: userNameController,
            decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(Icons.alternate_email_rounded)),
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                hintText: "Username",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Username is required';
              }
              // else {
              //   bool isValid = EmailValidator.validate(value);
              //   if (!isValid) {
              //     return 'Please enter a valid email Address';
              //   }
              // }
              return null;
            }));

    final signUpButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: const Color.fromARGB(255, 198, 255, 27)),
        onPressed: () async {
          setState(() {
            displayName = '$firstNameController.text $lastNameController.text';
            address = "$stateValue, $countryValue";
            (stateValue != '')
                ? address = "$stateValue, $countryValue"
                : address = countryValue;
          });

          if (signUpFormKey.currentState!.validate()) {
            final signUpSuccess = await context.read<AuthProvider>().signUp(
                  firstNameController.text,
                  lastNameController.text,
                  birthDateController.text,
                  address,
                  emailController.text,
                  passwordController.text,
                  displayName,
                  userNameController.text,
                );
            if (signUpSuccess) {
              Navigator.pop(context);
            }
          }
        },
        child: const SizedBox(
            height: 40,
            child: Center(
                child: Text('Sign Up',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    )))),
      ),
    );

    final backButton = Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: const Color.fromARGB(255, 198, 255, 27)),
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const SizedBox(
            height: 40,
            child: Center(
                child: Text('Back',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    )))),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: signUpFormKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          children: <Widget>[
            const Text(
              "Sign Up",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            firstName,
            lastName,
            birthDate,
            location,
            const Divider(
              height: 0,
              color: Colors.black12,
              thickness: 0.8,
            ),
            email,
            password,
            userName,
            const SizedBox(
              height: 10,
            ),
            signUpButton,
            backButton
          ],
        ),
      )),
    );
  }
}
