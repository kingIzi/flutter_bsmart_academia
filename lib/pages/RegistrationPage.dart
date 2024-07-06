import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_async_autocomplete/flutter_async_autocomplete.dart';
import 'package:namer_app/components/forms/add_student_form.dart';
import 'package:namer_app/core/entities/Facility.dart';
import 'package:namer_app/core/utilities/app_config.dart';
import 'package:namer_app/core/utilities/helpers.dart';
import 'package:namer_app/core/utilities/local_response_model.dart';
import 'package:namer_app/customs/custom_phone_text_field.dart';
import 'package:namer_app/customs/custom_text_fields.dart';
import 'package:namer_app/services/api/auth_requests.dart';

// class FacilityController extends TextEditingController {
//   int? facilityId;
//   FacilityController({super.text, this.facilityId});
// }

// class StudentDetail {
//   final FacilityController facilityRegSno;
//   final TextEditingController admissionNo;

//   const StudentDetail(
//       {required this.facilityRegSno, required this.admissionNo});

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'Facility_Reg_Sno': facilityRegSno.facilityId,
//       'Admission_No': admissionNo.text
//     };
//   }
// }

class AccountInfoControllers {
  final TextEditingController fullNameController;
  final MobileNumberController phoneNumberController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final List<StudentDetail> studentDetails;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Parent_Name': fullNameController.text,
      'Mobile_No': phoneNumberController.prefix! + phoneNumberController.text,
      'User_Name': usernameController.text,
      'Email_Address': emailController.text,
      'SDetails': studentDetails.map((e) => e.toMap()).toList()
    };
  }

  const AccountInfoControllers(
      {required this.fullNameController,
      required this.phoneNumberController,
      required this.usernameController,
      required this.emailController,
      required this.studentDetails});
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late BuildContext _buildContext;
  int currentStep = 0;
  final _accountInfoFormKey = GlobalKey<FormState>();
  final _studentDetailsFormKey = GlobalKey<FormState>();
  late final AccountInfoControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = AccountInfoControllers(
        fullNameController: TextEditingController(),
        phoneNumberController: MobileNumberController(),
        usernameController: TextEditingController(),
        emailController: TextEditingController(),
        studentDetails: [
          StudentDetail(
              admissionNo: TextEditingController(),
              facilityRegSno: FacilityController())
        ]);
  }

  void _completeFormToContinueSnackBar(String message) {
    final snackBar = SnackBar(
      content: const Text('Complete the form to continue.'),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    var messenger = ScaffoldMessenger.of(context);
    if (messenger.mounted) {
      messenger.removeCurrentSnackBar();
      messenger.showSnackBar(snackBar);
    } else {
      messenger.showSnackBar(snackBar);
    }
  }

  void _setTapped(int step) {
    setState(() {
      final isLastStep = step == 1;
      if (isLastStep) {
        final isValidAccountsInfo =
            _accountInfoFormKey.currentState!.validate();
        if (isValidAccountsInfo) {
          currentStep = step;
        } else {
          _completeFormToContinueSnackBar('Comple the form to continue');
        }
      } else {
        currentStep = step;
      }
    });
  }

  void _stepContinue(BuildContext context) {
    final isLastStep = (currentStep == getSteps().length - 1);
    if (isLastStep) {
      final isValidStudentDetails =
          _studentDetailsFormKey.currentState!.validate();
      _handleValidStudentDetails(isValidStudentDetails, context);
    } else {
      final isValidAccountInfo = _accountInfoFormKey.currentState!.validate();
      _handleValidAccountInfo(isValidAccountInfo);
    }
  }

  Future<Map<String, dynamic>> _requestParentRegistration(
      Map<String, dynamic> body) async {
    final response = await StudentDetailsApi.parentReg.sendRequest(body: body);
    return Future.value(response);
  }

  void registeredParentSucessfully(BuildContext context) {
    Navigator.of(context).pop();
  }

  // String _identifyRegistrationErrorMessage(String message) {
  //   final facilityPattern = RegExp(r'Facility No (\d+)');
  //   final admissionPattern = RegExp(r'Admission No (\d+)');
  //   if (facilityPattern.hasMatch(message)) {
  //     //final value = facilityPattern.firstMatch(message)!.group(1);
  //     final facilityName = _controllers.studentDetails[0].facilityRegSno.text;
  //     return '$facilityName is invalid.';
  //   } else if (admissionPattern.hasMatch(message)) {
  //     var admissionNo = admissionPattern.firstMatch(message)!.group(1);
  //     return 'Admission number $admissionNo is invalid.';
  //   } else {
  //     return message;
  //   }
  // }

  void parseParentRegistrationResponse(
      Map<String, dynamic> response, NavigatorState navigator) {
    if (response['response'] == null) {
      showErrorQuickAlert(navigator.context, 'Failed', response['message']);
      return;
    }
    final hasErrorResponse =
        LocalResponseModel.hasErrorResponse(response['response']);
    if (hasErrorResponse) {
      var statusMessage =
          LocalResponseModel.getErrorStatusFromResponse(response['response']);
      statusMessage = identifyStudentRegistrationErrorMessage(
          statusMessage, _controllers.studentDetails.first);
      showErrorQuickAlert(navigator.context, 'Failed', statusMessage);
    } else {
      showSuccessQuickAlert(navigator.context, 'Success',
          'Registered successfully!', registeredParentSucessfully);
    }
  }

  void _confirmRegistrationClicked(BuildContext context) async {
    final navigator = Navigator.of(context);
    showFetchingQuickAlert(navigator.context, 'You are being registered...');
    final body = _controllers.toMap();
    log(body.toString());
    final response = await _requestParentRegistration(body);
    if (navigator.context.mounted) navigator.pop();
    parseParentRegistrationResponse(response, navigator);
  }

  _handleValidStudentDetails(bool isValid, BuildContext context) {
    if (isValid) {
      showConfirmQuickAlert(context, 'Are you sure?', 'Do you want to register',
          _confirmRegistrationClicked);
    }
  }

  void _handleValidAccountInfo(bool isValid) {
    if (isValid) {
      setState(() {
        currentStep += 1;
      });
    } else {
      _completeFormToContinueSnackBar('Complete the form to continue.');
    }
  }

  List<Step> getSteps() {
    return <Step>[
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: const Text("Account Info"),
        content: getAccountInfoForm(),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text("Student details"),
        content: getStudentDetailsForm(
            _studentDetailsFormKey, _controllers.studentDetails[0]),
      ),
    ];
  }

  Form getAccountInfoForm() {
    return Form(
      key: _accountInfoFormKey,
      onChanged: () {
        Form.of(primaryFocus!.context!).save();
      },
      child: Column(
        children: [
          CustomTextFormField(
              validator: cannotBeBlankValidator,
              labelText: 'Full name',
              hintText: 'Full name',
              controller: _controllers.fullNameController,
              prefixIcon: Icons.person,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [
                LengthLimitingTextInputFormatter(255),
                FilteringTextInputFormatter.deny(
                  RegExp(r'[^a-zA-Z]\s'),
                )
              ]),
          const SizedBox(
            height: 12,
          ),
          CustomPhoneFormField(
              isRequired: true,
              hintText: 'Mobile Number',
              controller: _controllers.phoneNumberController),
          const SizedBox(
            height: 12,
          ),
          CustomTextFormField(
              validator: cannotBeBlankValidator,
              labelText: 'Username',
              hintText: 'Username',
              controller: _controllers.usernameController,
              prefixIcon: Icons.verified_user,
              textCapitalization: TextCapitalization.none,
              inputFormatters: [
                LengthLimitingTextInputFormatter(255),
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                FilteringTextInputFormatter.deny(
                  RegExp(r'[^a-zA-Z0-9]'),
                )
              ]),
          const SizedBox(
            height: 12,
          ),
          CustomTextFormField(
              validator: (value) => validateEmail(value, true),
              labelText: 'Email Address',
              hintText: 'Email Address',
              controller: _controllers.emailController,
              prefixIcon: Icons.email,
              textCapitalization: TextCapitalization.none,
              inputFormatters: [
                LengthLimitingTextInputFormatter(255),
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
              //physics: const NeverScrollableScrollPhysics(),
              child: Column(
            children: [
              Image.asset(
                'images/b-smart-acamedia-logo.png',
                scale: 2,
              ),
              Stepper(
                type: StepperType.vertical,
                currentStep: currentStep,
                physics: const ClampingScrollPhysics(),
                onStepCancel: () => currentStep == 0
                    ? null
                    : setState(() {
                        currentStep -= 1;
                      }),
                onStepContinue: () => _stepContinue(context),
                onStepTapped: _setTapped,
                steps: getSteps(),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already registered?'),
                      const SizedBox(width: 2),
                      InkWell(
                        child: Text(
                          'Login.',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        onTap: () {
                          //onPushRegistrationPage(context);
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ))
            ],
          )),
        ),
      ),
    );
  }
}
