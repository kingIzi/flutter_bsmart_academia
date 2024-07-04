import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namer_app/customs/custom_phone_text_field.dart';
import 'package:namer_app/customs/custom_text_fields.dart';

class StudentDetail {
  final TextEditingController facilityRegSno;
  final TextEditingController admissionNo;

  const StudentDetail(
      {required this.facilityRegSno, required this.admissionNo});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'facilityRegSno': facilityRegSno.text,
      'Admission_No': admissionNo.text
    };
  }
}

class AccountInfoControllers {
  final TextEditingController fullNameController;
  final TextEditingController phoneNumberController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final List<StudentDetail> studentDetails;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Parent_Name': fullNameController.text,
      'Mobile_No': phoneNumberController.text,
      'User_Name': usernameController.text,
      'Email_Address': emailController.text,
      'SDetails': studentDetails.map((e) => e.toMap())
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
  int currentStep = 0;
  final _accountInfoFormKey = GlobalKey<FormState>();
  final _studentDetailsFormKey = GlobalKey<FormState>();
  late final AccountInfoControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = AccountInfoControllers(
        fullNameController: TextEditingController(),
        phoneNumberController: TextEditingController(),
        usernameController: TextEditingController(),
        emailController: TextEditingController(),
        studentDetails: [
          StudentDetail(
              admissionNo: TextEditingController(),
              facilityRegSno: TextEditingController())
        ]);
  }

  @override
  void dispose() {
    // _controllers.fullNameController.dispose();
    // _controllers.phoneNumberController.dispose();
    // _controllers.usernameController.dispose();
    // _controllers.emailController.dispose();
    super.dispose();
  }

  String? _notEmptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be blank';
    } else {
      return null;
    }
  }

  void _stepContinue() {
    final isLastStep = (currentStep == getSteps().length - 1);
    if (isLastStep) {
      final isValidStudentDetails =
          _studentDetailsFormKey.currentState!.validate();
      _handleValidStudentDetails(isValidStudentDetails);
    } else {
      final isValidAccountInfo = _accountInfoFormKey.currentState!.validate();
      _handleValidAccountInfo(isValidAccountInfo);
    }
  }

  _handleValidStudentDetails(bool isValid) {
    if (isValid) {
      final body = _controllers.toMap();
      log(body.toString());
    }
  }

  void _handleValidAccountInfo(bool isValid) {
    if (isValid) {
      setState(() {
        currentStep += 1;
      });
    }
  }

  List<Step> getSteps() {
    return <Step>[
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: const Text("Account Info"),
        content: Form(
          key: _accountInfoFormKey,
          child: Column(
            children: [
              CustomTextFormField(
                  validator: _notEmptyValidator,
                  labelText: 'Full name',
                  hintText: 'Full name',
                  controller: _controllers.fullNameController,
                  prefixIcon: Icons.person,
                  textCapitalization: TextCapitalization.words,
                  inputFormatters: [LengthLimitingTextInputFormatter(255)]),
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
                  validator: _notEmptyValidator,
                  labelText: 'Username',
                  hintText: 'Username',
                  controller: _controllers.usernameController,
                  prefixIcon: Icons.verified_user,
                  textCapitalization: TextCapitalization.none,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(255),
                    FilteringTextInputFormatter.deny(RegExp(r'\s'))
                  ]),
              const SizedBox(
                height: 12,
              ),
              CustomTextFormField(
                  validator: _notEmptyValidator,
                  labelText: 'Email Address',
                  hintText: 'Email Address',
                  controller: _controllers.emailController,
                  prefixIcon: Icons.email,
                  textCapitalization: TextCapitalization.none,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(255),
                    FilteringTextInputFormatter.deny(RegExp(r'\s'))
                  ]),
            ],
          ),
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text("Student details"),
        content: Form(
          key: _studentDetailsFormKey,
          child: Column(
            children: [
              CustomTextFormField(
                  validator: _notEmptyValidator,
                  labelText: 'Facility',
                  hintText: 'Facility',
                  controller: _controllers.studentDetails[0].facilityRegSno,
                  prefixIcon: Icons.school,
                  textCapitalization: TextCapitalization.none,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(255),
                  ]),
              CustomTextFormField(
                  validator: _notEmptyValidator,
                  labelText: 'Admission Number',
                  hintText: 'Admission Number',
                  controller: _controllers.studentDetails[0].admissionNo,
                  prefixIcon: Icons.hdr_auto,
                  textCapitalization: TextCapitalization.none,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(255),
                  ]),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
                onStepContinue: _stepContinue,
                onStepTapped: (step) => setState(() {
                  final isValid = _accountInfoFormKey.currentState!.validate();
                  if (step == 1 && isValid) {
                    currentStep = step;
                  }
                }),
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
