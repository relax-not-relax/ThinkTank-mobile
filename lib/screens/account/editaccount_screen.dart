import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thinktank_mobile/api/account_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/logininfo.dart';
import 'package:thinktank_mobile/screens/account/account_mainscreen.dart';
import 'package:thinktank_mobile/screens/account/changepassword_screen.dart';
import 'package:thinktank_mobile/widgets/appbar/normal_appbar.dart';
import 'package:thinktank_mobile/widgets/others/datetime_picker.dart';
import 'package:thinktank_mobile/widgets/others/editaccount_field.dart';
import 'package:thinktank_mobile/widgets/others/editaccountpass_field.dart';
import 'package:thinktank_mobile/widgets/others/selector_form.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';
import 'package:http/http.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({
    super.key,
    required this.account,
  });

  final Account account;

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  late String birthday;
  late String gender;
  late Future<LoginInfo?> _loginFuture;
  TextEditingController _controller = TextEditingController();
  late String oldPassword;
  File? _selectedImage;
  bool _isNullField = false;
  late String avatar;
  late int id;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.account.fullName;
    _userNameController.text = widget.account.userName;
    _emailController.text = widget.account.email;
    birthday = widget.account.dateOfBirth!;
    gender = widget.account.gender ?? "Male";
    avatar = widget.account.avatar ??
        "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/0%2FUntitled%20design%20%281%29.png?alt=media&token=a68548c0-4658-4525-ab56-67516c399b0b";
    id = widget.account.id;
    _loginFuture = SharedPreferencesHelper.getAccount();
    _loginFuture.then((loginInfo) {
      setState(() {
        if (loginInfo != null) {
          _controller.text = loginInfo.password;
          oldPassword = loginInfo.password;
        }
      });
    });
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
    // print(response);
  }

  void handlePageChange(String newBirthday) {
    setState(() {
      birthday = newBirthday;
    });
  }

  void handleGenderChange(String newGender) {
    setState(() {
      gender = newGender;
    });
  }

  Future<void> _changePassword() async {
    final newPassword = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePasswordScreen(),
      ),
    );

    if (newPassword != null) {
      setState(() {
        _controller.text = newPassword;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future displayBottomSheet(BuildContext context) {
      return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 200,
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 40.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
                child: Row(
                  children: [
                    Container(
                      width: 50.0,
                      height: 50.0,
                      //padding: const EdgeInsets.all(20.0),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 217, 217, 217),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                      child: const Icon(
                        IconlyBold.image,
                        color: Color.fromARGB(255, 45, 64, 89),
                        size: 30.0,
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Choose from library",
                      style: GoogleFonts.roboto(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Container(
                      width: 50.0,
                      height: 50.0,
                      //padding: const EdgeInsets.all(20.0),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 217, 217, 217),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                      child: const Icon(
                        IconlyBold.close_square,
                        color: Color.fromARGB(255, 234, 84, 84),
                        size: 30.0,
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Remove current picture",
                      style: GoogleFonts.roboto(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 234, 84, 84),
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

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: const TNormalAppbar(title: "Edit profile"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  _selectedImage != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(_selectedImage!),
                          radius: 50,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(avatar),
                          radius: 50,
                        ),
                  // CircleAvatar(
                  //   backgroundImage: NetworkImage(widget.account.avatar!),
                  //   radius: 50,
                  // ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  TextButton(
                    onPressed: () {
                      displayBottomSheet(context);
                    },
                    child: Text(
                      "Change profile photo",
                      style: GoogleFonts.inter(
                        color: Color.fromARGB(255, 137, 184, 245),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EditAccountField(
                      controller: _nameController,
                      title: "Name",
                    ),
                    const SizedBox(height: 20),
                    EditAccountField(
                      controller: _userNameController,
                      title: "Username",
                    ),
                    const SizedBox(height: 20),
                    EditAccountField(
                      controller: _emailController,
                      title: "Email",
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: DatePickerNormal(
                            date: birthday,
                            onDateChanged: handlePageChange,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 6,
                          child: SelectorForm(
                              genderInput: gender,
                              onGenderChanged: handleGenderChange),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    EditAccountPassField(
                      controllerPass: _controller,
                      title: "Password",
                      openChange: _changePassword,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                _showResizableDialog(context);

                if (_selectedImage != null) {
                  String response = await ApiAccount.addFile(
                      _selectedImage!.path, widget.account.accessToken!);
                  setState(() {
                    avatar = response;
                  });
                }

                if (gender == "") {
                  setState(() {
                    gender = "Male";
                  });
                }

                Account? updatedAccount = await ApiAccount.updateProfile(
                  _nameController.text,
                  _userNameController.text,
                  _emailController.text,
                  gender,
                  birthday,
                  avatar,
                  oldPassword,
                  _controller.text,
                  widget.account.accessToken!,
                  id,
                );

                if (updatedAccount == null) {
                  print("Can not update!");
                  // ignore: use_build_context_synchronously
                  _closeDialog(context);
                } else {
                  await SharedPreferencesHelper.saveInfo(updatedAccount);

                  // ignore: use_build_context_synchronously
                  _closeDialog(context);

                  Future.delayed(const Duration(seconds: 2), () {
                    // ignore: use_build_context_synchronously
                    _showResizableDialogSuccess(context);
                  });
                }
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
          ],
        ),
      ),
    );
  }
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
                  'Please wait a moment, your profile is updating.',
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
              const CustomLoadingSpinner(),
            ],
          ),
        ),
      );
    },
  );
}

void _showResizableDialogSuccess(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          width: 250,
          height: 300,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromARGB(255, 249, 249, 249)),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/pics/check1.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Successfully updated!',
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
                  'Let we know more about you.',
                  style: TextStyle(
                      color: Color.fromRGBO(129, 140, 155, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _closeDialog(BuildContext context) {
  Navigator.of(context).pop();
}
