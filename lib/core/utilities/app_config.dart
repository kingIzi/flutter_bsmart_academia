import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

void showFetchingQuickAlert(BuildContext context, String text) {
  QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Loading',
      text: text,
      barrierDismissible: false,
      disableBackBtn: true);
}

void showErrorQuickAlert(BuildContext context, String title, String text) {
  QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: title,
      text: text,
      confirmBtnColor: Theme.of(context).colorScheme.secondary,
      barrierDismissible: false);
}

void showInfoQuickAlert(BuildContext context, String title, String text) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.info,
    title: title,
    text: text,
  );
}

void showConfirmQuickAlert(BuildContext context, String title, String text,
    Function(BuildContext) onConfirmClicked) {
  QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: title,
      text: text,
      confirmBtnText: 'Confirm',
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      onConfirmBtnTap: () {
        if (context.mounted) Navigator.of(context).pop();
        onConfirmClicked(context);
      });
}

void showSuccessQuickAlert(BuildContext context, String title, String text,
    Function(BuildContext) onConfirmClicked) {
  QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: title,
      text: text,
      barrierDismissible: false,
      disableBackBtn: true,
      onConfirmBtnTap: () {
        if (context.mounted) Navigator.of(context).pop();
        onConfirmClicked(context);
      });
}

SlideTransition simpleSlideRouteTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    Offset begin,
    Offset end,
    CurveTween curve) {
  final tween = Tween(begin: begin, end: end).chain(curve);
  final offsetAnimation = animation.drive(tween);
  return SlideTransition(position: offsetAnimation, child: child);
}

String? cannotBeBlankValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Cannot be blank';
  } else {
    return null;
  }
}

String? validateEmail(String? value, bool isRequired) {
  if (isRequired && (value == null || value.isEmpty)) {
    return 'Cannot be blank';
  }
  if (value != null && value.isNotEmpty && !EmailValidator.validate(value)) {
    return 'Invalid email address';
  }
  return null;
}
