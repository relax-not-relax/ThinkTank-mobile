import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/logininfo.dart';
import 'package:thinktank_mobile/widgets/appbar/normal_appbar.dart';
import 'package:thinktank_mobile/widgets/others/editPass_field.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late Future<LoginInfo?> _loginFuture;
  bool _isPasswordMismatch = false;
  bool _isInCorrectOldPassword = false;
  bool _isUnChecked = false;
  bool _isValid = false;
  String errorText = "";

  String passCheck = "";

  @override
  void initState() {
    super.initState();
    _newPasswordController.text = "";
    _confirmPasswordController.text = "";
    _loginFuture = SharedPreferencesHelper.getAccount();
    _loginFuture.then((loginInfo) {
      setState(() {
        if (loginInfo != null) {
          _passwordController.text = loginInfo.password;
          passCheck = loginInfo.password;
        }
      });
    });
  }

  void _validateAndSave() {
    final passwordRegex =
        RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,12}$');

    if (_passwordController.text != passCheck) {
      setState(() {
        _isInCorrectOldPassword = true;
      });
    } else {
      _isInCorrectOldPassword = false;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _isPasswordMismatch = true;
      });
    } else {
      setState(() {
        _isPasswordMismatch = false;
      });
    }

    if (_newPasswordController.text != "") {
      if (_newPasswordController.text.contains(' ')) {
        setState(() {
          _isUnChecked = true;
          errorText = "Password must not contain spaces!";
        });
      } else {
        _isUnChecked = false;
      }

      _isValid = passwordRegex.hasMatch(_newPasswordController.text);
      if (_isValid) {
        setState(() {
          _isUnChecked = false;
        });
      } else {
        setState(() {
          _isUnChecked = true;
          errorText =
              "Password must have at least one number, one lowercase letter, one uppercase letter, and be between 8 and 12 characters long";
        });
      }
    }

    if (_isInCorrectOldPassword == false && _isPasswordMismatch == false) {
      if (_newPasswordController.text == "") {
        setState(() {
          _newPasswordController.text = _passwordController.text;
        });
        Navigator.pop(context, _newPasswordController.text);
      } else if (_newPasswordController.text != "" &&
          _isUnChecked == false &&
          _isValid) {
        Navigator.pop(context, _newPasswordController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: const TNormalAppbar(
        title: "Change password",
        showBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EditPasswordField(
                      controllerPass: _passwordController,
                      title: "Old password",
                      errorText: _isInCorrectOldPassword
                          ? 'Old password is incorrect'
                          : null,
                      borderColor: _isInCorrectOldPassword ? Colors.red : null,
                    ),
                    const SizedBox(height: 20),
                    EditPasswordField(
                      controllerPass: _newPasswordController,
                      title: "New password",
                      errorText: _isUnChecked ? errorText : null,
                      borderColor: _isUnChecked ? Colors.red : null,
                    ),
                    const SizedBox(height: 20),
                    EditPasswordField(
                      controllerPass: _confirmPasswordController,
                      title: "Confirm password",
                      errorText: _isPasswordMismatch
                          ? 'Confirm password does not match the new password!'
                          : null,
                      borderColor: _isPasswordMismatch ? Colors.red : null,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  _validateAndSave();
                },
                style: buttonPrimary_3,
                child: Text(
                  "Save Changes",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
