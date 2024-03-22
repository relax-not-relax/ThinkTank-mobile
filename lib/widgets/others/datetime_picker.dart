import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

class DatePickerNormal extends StatefulWidget {
  const DatePickerNormal({
    super.key,
    required this.date,
    required this.onDateChanged,
  });

  final String date;
  final Function(String) onDateChanged;

  @override
  State<DatePickerNormal> createState() => _DatePickerNormalState();
}

class _DatePickerNormalState extends State<DatePickerNormal> {
  late String parsedDate;
  late DateTime dateInput;

  @override
  void initState() {
    super.initState();

    dateInput = DateTime.parse(widget.date);
    parsedDate = DateFormat("d-M-y").format(dateInput);
  }

  void updateDate() async {
    final DateTime? datePicker = await showDatePicker(
      context: context,
      initialDate: dateInput,
      firstDate: DateTime(1900),
      lastDate: DateTime(3000),
    );
    if (datePicker != null) {
      setState(() {
        dateInput = datePicker;
      });
      widget.onDateChanged(
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(dateInput),
      );
    }
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    parsedDate = DateFormat("d-M-y").format(dateInput);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Birthday",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        ElevatedButton.icon(
          onPressed: () {
            updateDate();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 22, 22, 22),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                  color: Color.fromARGB(255, 102, 102, 102),
                ),
              ),
            ),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 13, horizontal: 15)),
          ),
          icon: const Icon(
            IconlyLight.calendar,
            color: Color.fromARGB(255, 139, 139, 139),
          ),
          label: Row(
            // Bọc Text bằng Row và thêm SizedBox
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 10), // Thêm khoảng cách ở đây
              Text(
                parsedDate,
                style: GoogleFonts.roboto(
                  color: Color.fromARGB(255, 139, 139, 139),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
