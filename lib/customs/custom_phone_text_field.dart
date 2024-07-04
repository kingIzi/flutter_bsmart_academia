import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CustomPhoneFormField extends StatefulWidget {
  const CustomPhoneFormField(
      {super.key,
      required this.isRequired,
      required this.hintText,
      required this.controller});
  final bool isRequired;
  final String hintText;
  final TextEditingController controller;

  @override
  State<CustomPhoneFormField> createState() => _CustomPhoneFormField();
}

class _CustomPhoneFormField extends State<CustomPhoneFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.hintText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 1,
        ),
        IntlPhoneField(
            controller: widget.controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialCountryCode: 'TZ',
            validator: (name) {
              if (widget.isRequired && name!.number.isEmpty) {
                return 'Cannot be blank';
              } else {
                return null;
              }
            },
            //inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: widget.hintText,
            )),
      ],
    );
  }
}
