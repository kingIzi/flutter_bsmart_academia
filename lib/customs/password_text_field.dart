import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextPasswordFormField extends StatefulWidget {
  const CustomTextPasswordFormField(
      {super.key,
      required this.validator,
      required this.labelText,
      required this.hintText,
      required this.controller,
      required this.prefixIcon,
      required this.inputFormatters});
  final String? Function(String?)? validator;
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final List<TextInputFormatter> inputFormatters;

  @override
  State<CustomTextPasswordFormField> createState() =>
      _CustomTextPasswordFormFieldState();
}

class _CustomTextPasswordFormFieldState
    extends State<CustomTextPasswordFormField> {
  //final _controller = TextEditingController();
  //String textValue = '';
  bool _obscureText = true;
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

  @override
  void dispose() {
    widget.controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clearText() {
    _obscureText = !_obscureText;
    setState(() {});
  }

  IconData _getVisibilityIcon() {
    return _obscureText ? Icons.visibility : Icons.visibility_off;
  }

  IconButton? _showVisibilityIcon() {
    if (widget.controller.text.isEmpty) {
      return null;
    } else {
      return IconButton(
          onPressed: _clearText, icon: Icon(_getVisibilityIcon()));
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
            obscureText: _obscureText,
            validator: widget.validator,
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
                suffixIcon: _showVisibilityIcon())),
      ],
    );
  }
}
