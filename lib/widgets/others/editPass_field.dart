import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditPasswordField extends StatefulWidget {
  const EditPasswordField({
    super.key,
    required this.controllerPass,
    required this.title,
    this.errorText,
    this.borderColor,
  });

  final TextEditingController controllerPass;
  final String title;
  final String? errorText;
  final Color? borderColor;

  @override
  State<EditPasswordField> createState() => _EditPasswordFieldState();
}

class _EditPasswordFieldState extends State<EditPasswordField> {
  late FocusNode _focusNode;
  late Color textColor;
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    textColor = const Color.fromARGB(255, 139, 139, 139);
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          textColor = Colors.white;
        });
      } else {
        setState(() {
          textColor = const Color.fromARGB(255, 139, 139, 139);
        });
      }
    });
  }

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
        TextFormField(
          controller: widget.controllerPass,
          focusNode: _focusNode,
          obscureText: _isObscured,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(
                color: widget.borderColor ??
                    const Color.fromARGB(255, 102, 102, 102),
                width: 1.0,
              ),
            ),
            errorText: widget.errorText,
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(
                color: Colors.white, // Màu viền khi có focus
                width: 1.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 7.0,
              horizontal: 10.0,
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 22, 22, 22),
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
      ],
    );
  }
}
