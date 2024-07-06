import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_async_autocomplete/flutter_async_autocomplete.dart';

class CustomSmartAutoComplete extends StatefulWidget {
  const CustomSmartAutoComplete(
      {super.key,
      required this.labelText,
      required this.controller,
      required this.getSuggestions,
      required this.hintText,
      required this.prefixIcon,
      required this.validator,
      required this.inputFormatters});

  final Future<List<String>> Function(String) getSuggestions;
  final String? Function(String?)? validator;
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final List<TextInputFormatter> inputFormatters;
  @override
  State<CustomSmartAutoComplete> createState() =>
      _CustomSmartAutoCompleteState();
}

class _CustomSmartAutoCompleteState extends State<CustomSmartAutoComplete> {
  bool showSuggestions = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.labelText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 1,
        ),
        AsyncAutocomplete(
          controller: widget.controller,
          validator: widget.validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: widget.hintText,
            prefixIcon: Icon(
              widget.prefixIcon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          asyncSuggestions: widget.getSuggestions,
          suggestionBuilder: (textValue) => ListTile(
            title: Text(textValue),
          ),
          onTapItem: (String value) {
            widget.controller.text = value;
          },
        )
      ],
    );
  }
}
