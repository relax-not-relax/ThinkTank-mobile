import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/api/achieviements_api.dart';
import 'package:thinktank_mobile/api/assets_api.dart';
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/api/contest_api.dart';
import 'package:thinktank_mobile/api/firebase_message_api.dart';
import 'package:thinktank_mobile/api/notification_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/contest.dart';
import 'package:thinktank_mobile/models/logininfo.dart';
import 'package:thinktank_mobile/screens/authentication/forgotpassscreen.dart';
import 'package:thinktank_mobile/screens/authentication/registerscreen.dart';
import 'package:thinktank_mobile/screens/home.dart';
import 'package:thinktank_mobile/screens/option_home.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late Future<LoginInfo?> _loginFuture;
  bool _isObscured = true;
  bool isRemember = false;
  bool _isIncorrect = false;

  @override
  void initState() {
    super.initState();
    _loginFuture = SharedPreferencesHelper.getAccount();
    _loginFuture.then((loginInfo) {
      setState(() {
        if (loginInfo != null) {
          _usernameController.text = loginInfo.username;
          _passwordController.text = loginInfo.password;
          isRemember = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration:
              const BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1)),
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                    Image.asset('assets/pics/hello1.png', width: 200),
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
                            style: TextStyle(color: Colors.red, fontSize: 25),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _usernameController,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
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
                            style: TextStyle(color: Colors.red, fontSize: 25),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: _isObscured,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
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
                    Visibility(
                      visible: _isIncorrect,
                      child: const Text(
                        'Incorrect username or password!',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              SizedBox(
                                height: 18,
                                width: 18,
                                child: Checkbox(
                                  checkColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  activeColor:
                                      const Color.fromRGBO(234, 84, 85, 1),
                                  value: isRemember,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isRemember = value!;
                                    });
                                    if (isRemember == false) {
                                      SharedPreferencesHelper.removeAccount();
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Remember me',
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPassScreen(),
                                ),
                              ).then((value) => {
                                    setState(() {
                                      _isIncorrect = false;
                                    })
                                  });
                            },
                            child: Text(
                              'Forgot password?',
                              style: GoogleFonts.roboto(
                                color: Color.fromRGBO(240, 123, 63, 1),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 1,
                            width: 100,
                            color: const Color.fromRGBO(217, 217, 217, 1),
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
                            color: const Color.fromRGBO(217, 217, 217, 1),
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
                            color: const Color.fromARGB(1, 202, 202, 202)
                                .withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: ElevatedButton(
                        style: buttonGoogleVer2(context),
                        onPressed: () async {
                          _showResizableDialog(context);
                          Account? acc =
                              await ApiAuthentication.loginWithGoogle();
                          if (acc == null) {
                            _closeDialog(context);
                          } else {
                            setState(() {
                              _isIncorrect = false;
                            });
                            await SharedPreferencesHelper.saveInfo(acc);
                            await ApiAchieviements.getLevelOfUser(
                                acc.id, acc.accessToken!);
                            int version = await SharedPreferencesHelper
                                .getResourceVersion();
                            await AssetsAPI.addAssets(
                                version, acc.accessToken!);
                            await ContestsAPI.getContets();
                            for (var e in await SharedPreferencesHelper
                                .getContests()) {
                              print(e.toJson());
                            }
                            _closeDialog(context);

                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen(
                                        inputScreen: OptionScreen(),
                                        screenIndex: 0,
                                      )),
                              (route) => false,
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/pics/google.png', height: 25),
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
                      onPressed: () async {
                        _showResizableDialog(context);
                        String usn = _usernameController.text;
                        String pass = _passwordController.text;
                        String? fcmToken =
                            await FirebaseMessageAPI().getToken();
                        Account? acc =
                            await ApiAuthentication.login(usn, pass, fcmToken!);
                        if (acc == null) {
                          print('sai');
                          setState(() {
                            _isIncorrect = true;
                          });
                          _closeDialog(context);
                        } else {
                          if (isRemember) {
                            await SharedPreferencesHelper.saveAccount(
                                LoginInfo(password: pass, username: usn));
                          }
                          setState(() {
                            _isIncorrect = false;
                          });
                          await SharedPreferencesHelper.saveInfo(acc);
                          await ApiAchieviements.getLevelOfUser(
                              acc.id, acc.accessToken!);
                          await ApiNotification.getNotifications();

                          int version = await SharedPreferencesHelper
                              .getResourceVersion();
                          await AssetsAPI.addAssets(version, acc.accessToken!);
                          _closeDialog(context);

                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen(
                                      inputScreen: OptionScreen(),
                                      screenIndex: 0,
                                    )),
                            (route) => false,
                          );
                        }
                      },
                      style: buttonPrimaryPinkVer2(context),
                      child: const Text(
                        'Sign in',
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
    );
  }
}

void _closeDialog(BuildContext context) {
  Navigator.of(context).pop();
}

void _showResizableDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Text(
                  'Please wait a moment, we are preparing for you...',
                  style: TextStyle(
                      color: Color.fromRGBO(129, 140, 155, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
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
