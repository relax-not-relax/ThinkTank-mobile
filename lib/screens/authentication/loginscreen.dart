import 'package:flutter/material.dart';
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/logininfo.dart';
import 'package:thinktank_mobile/screens/authentication/registerscreen.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

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
  bool _isObscured = true;
  bool isRemember = false;
  @override
  void initState() async {
    super.initState();
    LoginInfo? loginInfo = await SharedPreferencesHelper.getAccount();
    if (loginInfo != null) {
      _passwordController.text = loginInfo.password;
      _usernameController.text = loginInfo.username;
    }
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 150,
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
                        String usn = _usernameController.text;
                        String pass = _passwordController.text;
                        Account? acc =
                            await ApiAuthentication.postDataWithJson(usn, pass);
                        if (acc == null) {
                          print('loi dang nhap');
                        } else {
                          if (isRemember) {
                            await SharedPreferencesHelper.saveAccount(
                                LoginInfo(password: pass, username: usn));
                          }
                          print(acc.toString());
                        }
                      },
                      style: buttonPrimaryPink,
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
              Container(
                margin: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                    Image.asset('assets/pics/hello1.png', width: 230),
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
                      style: const TextStyle(fontSize: 20, color: Colors.black),
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
                      height: 30,
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
                      style: const TextStyle(fontSize: 20, color: Colors.black),
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
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text('Remember me')
                            ],
                          ),
                        ),
                        const Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                                color: Color.fromRGBO(240, 123, 63, 1)),
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
                        style: buttonGoogle,
                        onPressed: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}
