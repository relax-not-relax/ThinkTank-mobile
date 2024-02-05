import 'package:flutter/material.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

const TextStyle titleCreateAccount = TextStyle(
  color: Color.fromRGBO(45, 64, 89, 1),
  fontSize: 25,
  fontWeight: FontWeight.bold,
);
const TextStyle titleMini = TextStyle(
  color: Color.fromRGBO(45, 64, 89, 1),
  fontSize: 20,
  fontWeight: FontWeight.w500,
);
const TextStyle contentGray = TextStyle(
  color: Color.fromRGBO(45, 64, 89, 1),
  fontSize: 15,
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
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                    onPressed: () {},
                    style: buttonPrimaryPink,
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
            Container(
              margin: const EdgeInsets.all(14),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const Text(
                    'Create an account',
                    style: titleCreateAccount,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Please enter your full name, username, email address and password.',
                    style: contentGray,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
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
                          style: TextStyle(color: Colors.red, fontSize: 25),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  const TextField(
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    decoration: InputDecoration(
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
                          style: TextStyle(color: Colors.red, fontSize: 25),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  const TextField(
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    decoration: InputDecoration(
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
                          style: TextStyle(color: Colors.red, fontSize: 25),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  const TextField(
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    decoration: InputDecoration(
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
                          _isObscured ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 1,
                          width: 100,
                          color: Color.fromRGBO(217, 217, 217, 1),
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
                          color: Color.fromRGBO(217, 217, 217, 1),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Color.fromARGB(1, 202, 202, 202).withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 10,
                          offset: Offset(0, 3),
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
    );
  }
}

// Function để hiển thị dialog có thể thay đổi kích thước
void _showResizableDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          width: 250, // Điều chỉnh kích thước chiều rộng
          height: 400,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromARGB(
                  255, 249, 249, 249)), // Điều chỉnh kích thước chiều cao
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/pics/accOragne.png', // Thay thế bằng đường dẫn hình ảnh của bạn
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Successful!',
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
              const CustomLoadingSpinner(),
            ],
          ),
        ),
      );
    },
  );
}
