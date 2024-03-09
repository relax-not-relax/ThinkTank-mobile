import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:thinktank_mobile/screens/account/changepassword_screen.dart';

class EditAccountPassField extends StatefulWidget {
  const EditAccountPassField({
    super.key,
    required this.title,
    required this.controllerPass,
    required this.openChange,
  });

  final TextEditingController controllerPass;
  final String title;
  final VoidCallback openChange;

  @override
  State<EditAccountPassField> createState() => _EditAccountPassFieldState();
}

class _EditAccountPassFieldState extends State<EditAccountPassField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        InkWell(
          onTap: widget.openChange,
          child: IgnorePointer(
            child: TextFormField(
              obscureText: true,
              controller: widget.controllerPass,
              style: const TextStyle(
                color: Color.fromARGB(255, 139, 139, 139),
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 102, 102, 102),
                    width: 1.0,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 7.0,
                  horizontal: 10.0,
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 22, 22, 22),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
