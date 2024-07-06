import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField(
      {super.key,
      required this.validator,
      required this.labelText,
      required this.hintText,
      required this.controller,
      required this.prefixIcon,
      required this.inputFormatters,
      required this.textCapitalization});
  final String? Function(String?)? validator;
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final List<TextInputFormatter> inputFormatters;
  final TextCapitalization textCapitalization;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(
            () {}); // Rebuild the widget to show validation error if necessary
      }
    });
  }

  // @override
  // void dispose() {
  //   //widget.controller.dispose();
  //   _focusNode.dispose();
  //   super.dispose();
  // }

  void _clearText() {
    widget.controller.clear();
    setState(() {});
  }

  IconButton? showSuffixIcon() {
    if (widget.controller.text.isEmpty) {
      return null;
    } else {
      return IconButton(onPressed: _clearText, icon: const Icon(Icons.clear));
    }
  }

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
        TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSaved: (String? value) {
              setState(() {});
            },
            validator: widget.validator,
            textCapitalization: widget.textCapitalization,
            inputFormatters: widget.inputFormatters,
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
                suffixIcon: showSuffixIcon()))
      ],
    );
  }
}
