import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:namer_app/core/utilities/helpers.dart';
//import 'package:intl_phone_field/phone_number.dart';
//import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CustomPhoneFormField extends StatefulWidget {
  const CustomPhoneFormField(
      {super.key,
      required this.isRequired,
      required this.hintText,
      required this.controller});
  final bool isRequired;
  final String hintText;
  final MobileNumberController controller;

  @override
  State<CustomPhoneFormField> createState() => _CustomPhoneFormField();
}

class _CustomPhoneFormField extends State<CustomPhoneFormField> {
  final _phoneKey = GlobalKey<State<IntlPhoneField>>();
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
            key: _phoneKey,
            controller: widget.controller,
            onSaved: (PhoneNumber? value) {
              setState(() {
                if (value != null) {
                  widget.controller.prefix = value.countryCode.startsWith('+')
                      ? value.countryCode.substring(1)
                      : value.countryCode;
                } else {
                  widget.controller.prefix = '0';
                }
              });
            },
            autovalidateMode: AutovalidateMode.always,
            initialCountryCode: 'TZ',
            keyboardType: TextInputType.phone,
            validator: (PhoneNumber? phoneNumber) {
              if (widget.isRequired &&
                  (phoneNumber == null || phoneNumber.number.isEmpty)) {
                return 'Cannot be blank';
              }
              return null;
              //return 'Please enter a valid phone number';
            },
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
