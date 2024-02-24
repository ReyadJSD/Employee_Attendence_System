import 'package:attendanceapp/homescreen.dart';
import 'package:attendanceapp/loginscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController retypePassController = TextEditingController();
  double screenHeight = 0;
  double screenWidth = 0;
  bool isKeyboardVisible = false;
  Color primary = const Color(0xffeef444c);
  late SharedPreferences sharedPreferences;
  @override
  void setVisibility() {
    isKeyboardVisible = true;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          isKeyboardVisible
              ? SizedBox(height: screenHeight / 35)
              : Container(
            height: screenHeight / 3,
            width: screenWidth,
            decoration: BoxDecoration(
                color: primary,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(70),
                )),
            child: Center(
              child: Image.asset(
                "assets/icon/icon.png",
                width: screenWidth / 2.5,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: screenHeight / 50,
              bottom: screenWidth / 50,
            ),
            child: Text(
              'Signup Here',
              style: TextStyle(
                fontSize: screenHeight / 18,
                fontFamily: "Nexa Bold",
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: screenWidth / 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fieldTitle('Employee ID'),
                    customField('Write an employee id', idController, false),
                    fieldTitle('Password'),
                    customField('Write a password', passController, true),
                    fieldTitle('Re-type Password'),
                    customField('Re-type a password', retypePassController, true),
                    GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        String id = idController.text.trim();
                        String password = passController.text.trim();
                        String retypePassword = retypePassController.text.trim();

                        if (password != retypePassword) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Password and Re-type Password do not match'),
                          ));
                          return;
                        }

                        if (id.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Employee ID or Password is empty'),
                          ));
                          return;
                        }
                        try {
                          await FirebaseFirestore.instance.collection("Employee").doc().set({
                            'id': id,
                            'password': password,
                          });

                          // Show a SnackBar indicating successful signup
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Signup Successfully'),
                          ));

                          // Navigate to the LoginScreen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Error occurred while signing up'),
                          ));
                        }
                      },
                      child: Container(
                        height: 60,
                        width: screenWidth,
                        margin: EdgeInsets.only(top: screenHeight / 45),
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: const BorderRadius.all(Radius.circular(30))),
                        child: Center(
                          child: Text(
                            'Signup',
                            style: TextStyle(
                                fontSize: screenWidth / 22,
                                fontFamily: "Nexa Bold",
                                color: Colors.white,
                                letterSpacing: 2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 70),
                        child: const Row(
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Text(
        title,
        style: TextStyle(fontFamily: "Nexa Bold", fontSize: screenWidth / 22),
      ),
    );
  }

  Widget customField(String hint, TextEditingController controller, bool obscure) {
    return Container(
      width: screenWidth,
      margin: EdgeInsets.only(bottom: screenHeight / 50),
      decoration:const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(2, 2))
          ]),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth / 6,
            child: Icon(
              Icons.person,
              color: primary,
              size: screenWidth / 15,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth / 12),
              child: TextFormField(
                controller: controller,
                enableSuggestions: false,
                autocorrect: false,
                onTap: setVisibility,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: screenHeight / 35),
                  border: InputBorder.none,
                  hintText: hint,
                ),
                maxLines: 1,
                obscureText: obscure,
              ),
            ),
          )
        ],
      ),
    );
  }
}
