import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:namer_app/core/entities/GetSDetail.dart';
import 'package:namer_app/core/utilities/app_config.dart';
import 'package:namer_app/core/utilities/local_response_model.dart';
import 'package:namer_app/customs/custom_text_fields.dart';
import 'package:namer_app/customs/password_text_field.dart';
import 'package:namer_app/pages/RegistrationPage.dart';
import 'package:namer_app/pages/StudentAccountPage.dart';
import 'package:namer_app/services/api/auth_requests.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:namer_app/services/shared_prefs_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      color: const Color(0xffF4F6F8),
      //color: Theme.of(context).colorScheme.primaryContainer,
      child: LoaderOverlay(
          useDefaultLoading: false,
          overlayWidgetBuilder: (dynamic? progress) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.beat(
                      color: Theme.of(context).colorScheme.primary, size: 32),
                  if (progress != null) Text(progress)
                ],
              ),
            );
          },
          child: SafeArea(
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Scaffold(
                backgroundColor: Color(0xffF4F6F8),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: LoginForm(),
                  ),
                ),
              );
            }),
          )),
    ));
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({
    super.key,
  });

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final sharedPrefs = SharedPrefsService();

  void _createRegistrationRoute(BuildContext context) {
    final registrationPage = _registrationRoute();
    Navigator.of(context).push(registrationPage);
  }

  Route _registrationRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const RegistrationPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            simpleSlideRouteTransition(
                context,
                animation,
                secondaryAnimation,
                child,
                const Offset(1.0, 0.0),
                Offset.zero,
                CurveTween(curve: Curves.easeIn)));
  }

  Route _studentAccountsPageRoute(List<GetSDetail> students) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            StudentAccountPage(students: students),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            simpleSlideRouteTransition(
                context,
                animation,
                secondaryAnimation,
                child,
                const Offset(0.0, 1.0),
                Offset.zero,
                CurveTween(curve: Curves.easeIn)));
  }

  void showLoginFailedMessage(NavigatorState navigator, Iterable response) {
    final statusMessage =
        LocalResponseModel.getErrorStatusFromResponse(response);
    showErrorQuickAlert(navigator.context, 'Incorrect', statusMessage);
  }

  void _determineLoginState(NavigatorState navigator, Iterable response) {
    final hasErrorResponse = LocalResponseModel.hasErrorResponse(response);
    if (hasErrorResponse) {
      showLoginFailedMessage(navigator, response);
    } else {
      _handleLoginSuccess(navigator, response);
    }
  }

  void _handleLoginClicked(
      Map<String, String> loginRequestBody, BuildContext context) async {
    showFetchingQuickAlert(context, 'Attempting login...');
    final navigator = Navigator.of(context);
    try {
      final response = await SchoolDetailsApi.getSDetails
          .sendRequest(body: loginRequestBody);
      if (navigator.context.mounted) navigator.pop();
      if (response['response'] == null) throw response['message'];
      _determineLoginState(navigator, response['response']);
    } catch (e) {
      showErrorQuickAlert(navigator.context, 'Failed', e.toString());
    }
  }

  void _pushStudentAccountsPage(NavigatorState navigator, Iterable response) {
    final students = (response.first['Students'] as List)
        .map((e) => GetSDetail.fromJson(e))
        .toList();
    if (navigator.context.mounted) {
      final studentsAccountPage = _studentAccountsPageRoute(students);
      navigator.pushReplacement(studentsAccountPage);
    }
  }

  void _handleLoginSuccess(NavigatorState navigator, Iterable response) {
    assert(response.isNotEmpty);
    try {
      sharedPrefs
          .storeString('User_Name', _usernameController.text)
          .then((onValue) => _pushStudentAccountsPage(navigator, response))
          .catchError((onError) => throw onError);
    } catch (e) {
      showErrorQuickAlert(
          navigator.context, 'Failed', 'An unexpected error occured.');
    }
  }

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Image.asset('images/b-smart-acamedia-logo.png'),
            const SizedBox(height: 32),
            const Text(
              'Welcome to B-Smart Academia App',
              style: TextStyle(
                  fontWeight: FontWeight.bold, letterSpacing: 3, fontSize: 16),
            ),
            const Text(
              'Please login,',
              style: TextStyle(letterSpacing: 2),
            ),
          ],
        ),
        const SizedBox(height: 32),
        LoginFormFields(
          onPushRegistrationPage: widget._createRegistrationRoute,
          onLoginClicked: widget._handleLoginClicked,
          usernameController: widget._usernameController,
          passwordController: widget._passwordController,
        )
      ],
    );
  }
}

class LoginFormFields extends StatelessWidget {
  LoginFormFields(
      {super.key,
      required this.onPushRegistrationPage,
      required this.onLoginClicked,
      required this.usernameController,
      required this.passwordController});
  final _loginFormKey = GlobalKey<FormState>();
  //final _usernameController = TextEditingController();
  //final _passwordController = TextEditingController();
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final Function onPushRegistrationPage;
  final Function onLoginClicked;

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username cannot be blank';
    } else {
      return null;
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be blank';
    } else {
      return null;
    }
  }

  Map<String, String> getLoginBody() {
    final body = {
      'User_Name': usernameController.text,
      'Password': passwordController.text
    };
    return body;
  }

  void _attemptLoginUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    var isValid = _loginFormKey.currentState!.validate();
    if (!isValid) return;
    final body = getLoginBody();
    onLoginClicked(body, context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!
        .copyWith(color: theme.colorScheme.onPrimary);

    return Form(
      key: _loginFormKey,
      onChanged: () {
        Form.of(primaryFocus!.context!).save();
      },
      child: Column(
        children: [
          CustomTextFormField(
              validator: _validateUsername,
              labelText: 'Username',
              hintText: 'Enter username',
              controller: usernameController,
              prefixIcon: Icons.email,
              textCapitalization: TextCapitalization.none,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                LengthLimitingTextInputFormatter(255)
              ]),
          const SizedBox(
            height: 12,
          ),
          CustomTextPasswordFormField(
            validator: _validatePassword,
            labelText: 'Password',
            hintText: 'Enter password',
            controller: passwordController,
            prefixIcon: Icons.lock,
            inputFormatters: [LengthLimitingTextInputFormatter(255)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  showInfoQuickAlert(
                      context, 'Sorry😭😭😭', 'Page not yet implemented.');
                },
                child: const Text('Lost your password?'),
              )
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          MaterialButton(
            minWidth: double.maxFinite, // set minWidth to maxFinite
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              _attemptLoginUser(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: style,
                ),
                const SizedBox(width: 8.00),
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 24,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 0,
          ),
          Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not registered.'),
                  const SizedBox(width: 2),
                  InkWell(
                    child: Text(
                      'Click here.',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    onTap: () {
                      onPushRegistrationPage(context);
                    },
                  )
                ],
              ))
        ],
      ),
    );
  }
}
