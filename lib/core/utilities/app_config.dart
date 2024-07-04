import 'dart:developer';

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
