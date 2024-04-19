// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/screens/authentication/loginscreen.dart';
import 'package:thinktank_mobile/screens/game/game_menu.dart';
import 'package:thinktank_mobile/screens/home.dart';
import 'package:thinktank_mobile/screens/option_home.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

const TextStyle titleCreateAccount = TextStyle(
  color: Color.fromRGBO(45, 64, 89, 1),
  fontSize: 25,
  fontWeight: FontWeight.bold,
);
const TextStyle titleMini = TextStyle(
  color: Color.fromRGBO(45, 64, 89, 1),
  fontSize: 14,
  fontWeight: FontWeight.w500,
);
const TextStyle contentGray = TextStyle(
  color: Color.fromARGB(255, 129, 140, 155),
  fontSize: 13,
  fontWeight: FontWeight.w400,
);

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return CreateAccountScreenState();
  }
}

class CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernamewController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isObscured = true;
  bool isIncorrect = true;
  String error = '';
  bool isValidEmail(String email) {
    RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return regex.hasMatch(email);
  }

  void singUp() async {
    setState(() {
      isIncorrect = false;
    });
    final passwordRegex =
        RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,12}$');
    String fullname = _fullnameController.text;
    String username = _usernamewController.text;
    String password = _passwordController.text;
    String email = _emailController.text;
    if (fullname.trim().isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        email.trim().isEmpty) {
      setState(() {
        error = "Please fill in all fields!";
        isIncorrect = true;
      });
      return;
    }
    if (fullname.length > 50) {
      setState(() {
        error = "Fullname must not greater than 50 character!";
        isIncorrect = true;
      });
      return;
    }
    if (username.length > 20) {
      setState(() {
        error = "Username must not greater than 20 character!";
        isIncorrect = true;
      });
      return;
    }
    if (password.length < 8 || password.length >= 12) {
      setState(() {
        error =
            "Password length must be at least 8 characters and maximum 12 characters !";
        isIncorrect = true;
      });
      return;
    }
    if (email.length > 255) {
      setState(() {
        error = "Email must not greater than 255 character!";
        isIncorrect = true;
      });
      return;
    }
    if (!isValidEmail(email)) {
      setState(() {
        error = "Email is invalid!";
        isIncorrect = true;
      });
      return;
    }
    if (username.contains(' ')) {
      setState(() {
        error = "username must not contain space character!";
        isIncorrect = true;
      });
      return;
    }
    if (password.contains(' ')) {
      setState(() {
        error = "password must not contain space character!";
        isIncorrect = true;
      });
      return;
    }
    if (!passwordRegex.hasMatch(password)) {
      setState(() {
        error =
            "Password must contain uppercase letters, lowercase letters, numbers and special characters!";
        isIncorrect = true;
      });
      return;
    }
    _showResizableDialog(context);
    Response response =
        await ApiAuthentication.register(fullname, username, email, password);
    _closeDialog(context);
    if (response.statusCode == 200) {
      setState(() {
        isIncorrect = false;
        error = '';
      });
      final jsonData = json.decode(response.body);
      Account account = Account.fromJson(jsonData);
      await SharedPreferencesHelper.saveInfo(account);
      _showSuccessDialog(context);
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
      });
    } else if (response.statusCode == 400) {
      setState(() {
        try {
          error = json.decode(response.body)['error'].toString();
        } catch (e) {
          error = json.decode(response.body)['errors'].toString();
        }

        isIncorrect = true;
      });
    } else {
      setState(() {
        error = 'Server error';
        isIncorrect = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration:
                const BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1)),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'Create an account',
                      style: titleCreateAccount,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Please enter your full name, username, email address and password.',
                      style: contentGray,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.all(14),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  Text(
                                    'Full Name',
                                    style: titleMini,
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    ' *',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 25),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            TextField(
                              controller: _fullnameController,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  Text(
                                    'Username',
                                    style: titleMini,
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    ' *',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 25),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            TextField(
                              controller: _usernamewController,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  Text(
                                    'Email',
                                    style: titleMini,
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    ' *',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 25),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            TextField(
                              controller: _emailController,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  Text(
                                    'Password',
                                    style: titleMini,
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    ' *',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 25),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            TextField(
                              controller: _passwordController,
                              obscureText: _isObscured,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                              decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.amber),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscured
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscured = !_isObscured;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Visibility(
                                  visible: isIncorrect,
                                  child: Text(
                                    error,
                                    style: const TextStyle(color: Colors.red),
                                  )),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 1,
                                    width: 100,
                                    color:
                                        const Color.fromRGBO(217, 217, 217, 1),
                                  ),
                                  const Text(
                                    '   or   ',
                                    style: TextStyle(
                                      color: Color.fromRGBO(217, 217, 217, 1),
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    width: 100,
                                    color:
                                        const Color.fromRGBO(217, 217, 217, 1),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(1, 202, 202, 202)
                                            .withOpacity(0.2),
                                    spreadRadius: 4,
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: ElevatedButton(
                                style: buttonGoogle,
                                onPressed: () {
                                  _showResizableDialog(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/pics/google.png',
                                        height: 25),
                                    const Text(
                                      '   Continue with Google',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(1, 156, 156, 156)
                              .withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: singUp,
                        style: buttonPrimaryPinkVer2(context),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showResizableDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          width: 250,
          height: 400,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromARGB(255, 249, 249, 249)),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/pics/accOragne.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Please wait...',
                style: TextStyle(
                    color: Color.fromRGBO(234, 84, 85, 1),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'Please wait a moment, we are preparing for you...',
                style: TextStyle(
                    color: Color.fromRGBO(129, 140, 155, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              const CustomLoadingSpinner(
                  color: Color.fromARGB(255, 245, 149, 24)),
            ],
          ),
        ),
      );
    },
  );
}

void _showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          width: 250,
          height: 400,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromARGB(255, 249, 249, 249)),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/pics/accOragne.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Success',
                style: TextStyle(
                    color: Color.fromRGBO(234, 84, 85, 1),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'Welcome to ThinkTank!',
                style: TextStyle(
                    color: Color.fromRGBO(129, 140, 155, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              const CustomLoadingSpinner(
                  color: Color.fromARGB(255, 245, 149, 24)),
            ],
          ),
        ),
      );
    },
  );
}

void _closeDialog(BuildContext context) {
  Navigator.of(context).pop(); // Sử dụng Navigator để đóng AlertDialog
}
