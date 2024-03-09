import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditAccountField extends StatefulWidget {
  const EditAccountField({
    super.key,
    required this.text,
    required this.title,
  });

  final String text;
  final String title;

  @override
  State<EditAccountField> createState() => _EditAccountFieldState();
}

class _EditAccountFieldState extends State<EditAccountField> {
  late String textChange;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late Color textColor;

  @override
  void initState() {
    super.initState();
    textChange = widget.text;
    _controller = TextEditingController(text: textChange);
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
          controller: _controller,
          focusNode: _focusNode,
          style: TextStyle(color: textColor),
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(
                color: Colors.white, // Màu viền khi có focus
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
      ],
    );
  }
}
