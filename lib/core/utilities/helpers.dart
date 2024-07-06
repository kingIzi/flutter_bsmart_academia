import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:namer_app/components/forms/add_student_form.dart';
import 'package:namer_app/core/entities/GetSDetail.dart';
import 'package:namer_app/pages/StudentAccountPage.dart';

class MobileNumberController extends TextEditingController {
  String? prefix;
  MobileNumberController({super.text, this.prefix});
}

String identifyStudentRegistrationErrorMessage(
    String message, StudentDetail studentDetail) {
  final facilityPattern = RegExp(r'Facility No (\d+)');
  final admissionPattern = RegExp(r'Admission No (\d+)');
  if (facilityPattern.hasMatch(message)) {
    //final value = facilityPattern.firstMatch(message)!.group(1);
    final facilityName = studentDetail.facilityRegSno.text;
    return '$facilityName is invalid.';
  } else if (admissionPattern.hasMatch(message)) {
    var admissionNo = admissionPattern.firstMatch(message)!.group(1);
    return 'Admission number $admissionNo is invalid.';
  } else {
    return message;
  }
}
