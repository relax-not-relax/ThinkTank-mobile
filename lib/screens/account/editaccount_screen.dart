import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/logininfo.dart';
import 'package:thinktank_mobile/widgets/appbar/normal_appbar.dart';
import 'package:thinktank_mobile/widgets/others/datetime_picker.dart';
import 'package:thinktank_mobile/widgets/others/editaccount_field.dart';
import 'package:thinktank_mobile/widgets/others/editaccountpass_field.dart';
import 'package:thinktank_mobile/widgets/others/selector_form.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

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
  late String name;
  late String userName;
  late String email;
  late String birthday;
  late String? gender;
  late Future<LoginInfo?> _loginFuture;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    name = widget.account.fullName;
    userName = widget.account.userName;
    email = widget.account.email;
    birthday = widget.account.dateOfBirth!;
    gender = widget.account.gender ?? "Male";
    _loginFuture = SharedPreferencesHelper.getAccount();
    _loginFuture.then((loginInfo) {
      setState(() {
        if (loginInfo != null) {
          _controller.text = loginInfo.password;
        }
      });
    });
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
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.account.avatar!),
                    radius: 50,
                  ),
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
                      text: name,
                      title: "Name",
                    ),
                    const SizedBox(height: 20),
                    EditAccountField(
                      text: userName,
                      title: "Username",
                    ),
                    const SizedBox(height: 20),
                    EditAccountField(
                      text: email,
                      title: "Email",
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: DatePickerNormal(date: birthday),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 6,
                          child: SelectorForm(genderInput: gender!),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    EditAccountPassField(
                      controllerPass: _controller,
                      title: "Password",
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
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
