import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:namer_app/components/forms/add_student_form.dart';
import 'package:namer_app/core/utilities/app_config.dart';
import 'package:namer_app/core/utilities/helpers.dart';
import 'package:namer_app/core/utilities/local_response_model.dart';
import 'package:namer_app/services/api/auth_requests.dart';
import 'package:namer_app/services/reply_handler.dart';
import 'package:namer_app/services/shared_prefs_service.dart';

class AddStudentForm {
  String username;
  List<StudentDetail> studentDetails;

  AddStudentForm({required this.username, required this.studentDetails});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'User_Name': username,
      'SDetails': studentDetails.map((e) => e.toMap()).toList()
    };
  }
}

class Addstudentaccountpage extends StatefulWidget {
  const Addstudentaccountpage({super.key});

  @override
  State<Addstudentaccountpage> createState() => _AddstudentaccountpageState();
}

class _AddstudentaccountpageState extends State<Addstudentaccountpage> {
  final sharedPrefs = SharedPrefsService();
  final _detailsFormKey = GlobalKey<FormState>();
  final List<StudentDetail> studentDetails = [
    StudentDetail(
        admissionNo: TextEditingController(),
        facilityRegSno: FacilityController())
  ];

  void _popNavigator() {
    Navigator.of(context).pop();
  }

  void _parseAddStudentResponse(ResponseBody response) {
    final hasErrorResponse =
        LocalResponseModel.hasErrorResponse(response['response']);
    if (hasErrorResponse) {
      var statusMessage =
          LocalResponseModel.getErrorStatusFromResponse(response['response']);
      statusMessage = identifyStudentRegistrationErrorMessage(
          statusMessage, studentDetails.first);
      showErrorQuickAlert(context, 'Failed', statusMessage);
    } else {
      showSuccessQuickAlert(context, 'Success', 'Student added successfully!',
          (context) => _popNavigator());
    }
  }

  void _requestAddStudent(String username) async {
    assert(studentDetails.isNotEmpty || username.isNotEmpty);
    final body =
        AddStudentForm(username: username, studentDetails: studentDetails);
    showFetchingQuickAlert(context, 'Adding student...');
    try {
      StudentDetailsApi.addStudent
          .sendRequest(body: body.toMap())
          .then((response) {
        if (context.mounted) _popNavigator();
        if (response['response'] == null) throw response['message'];
        _parseAddStudentResponse(response);
      }).catchError((err) => throw err);
    } catch (e) {
      showErrorQuickAlert(context, 'Failed', e.toString());
    }
  }

  void _submitAddStudentAccountForm() {
    final isValidForm = _detailsFormKey.currentState!.validate();
    if (isValidForm) {
      try {
        sharedPrefs.readString('User_Name').then((username) {
          _requestAddStudent(username ?? '');
        }).catchError((err) => throw err);
      } catch (e) {
        showErrorQuickAlert(context, 'Access Denied', 'You need to login.');
      }
    }
  }

  List<Step> _getAddStudentAccountFormSteps() {
    return <Step>[
      Step(
        state: StepState.complete,
        title: const Text("Add Student details"),
        content: getStudentDetailsForm(_detailsFormKey, studentDetails.first),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage('images/bg-1.png'))),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              SafeArea(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _popNavigator();
                      },
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                    ),
                    const Text(
                      'Add Student',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  ],
                ),
              )),
              Expanded(
                  child: Container(
                width: double.maxFinite,
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(0.0, 10.0),
                          blurRadius: 10.0,
                          spreadRadius: 2.0),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0))),
                child: Stepper(
                  type: StepperType.vertical,
                  currentStep: 0,
                  onStepContinue: () {
                    _submitAddStudentAccountForm();
                  },
                  physics: const ClampingScrollPhysics(),
                  onStepCancel: _popNavigator,
                  steps: _getAddStudentAccountFormSteps(),
                ),
              ))
            ],
          ),
        ),
      );
    });
  }
}
