import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/data/data.dart';

class SelectorForm extends StatefulWidget {
  const SelectorForm({
    super.key,
    required this.genderInput,
    required this.onGenderChanged,
  });

  final String genderInput;
  final Function(String) onGenderChanged;

  @override
  State<SelectorForm> createState() => _SelectorFormState();
}

class _SelectorFormState extends State<SelectorForm> {
  late String _genderSelector;

  @override
  void initState() {
    super.initState();
    _genderSelector = genders.contains(widget.genderInput)
        ? widget.genderInput
        : genders.first;
  }

  void _onDropdownChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _genderSelector = newValue;
      });
      widget.onGenderChanged(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gender",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        DropdownButtonHideUnderline(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            decoration: BoxDecoration(
              border: Border.all(
                  color: const Color.fromARGB(255, 102, 102, 102), width: 1), //
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 22, 22, 22),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _genderSelector,
              onChanged: _onDropdownChanged,
              items: genders.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              style: GoogleFonts.roboto(
                color: const Color.fromARGB(255, 139, 139, 139),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
