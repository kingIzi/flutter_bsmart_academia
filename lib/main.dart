import 'package:flutter/material.dart';
import 'package:namer_app/core/entities/GetSDetail.dart';
import 'package:namer_app/core/utilities/routes.dart';
import 'package:namer_app/pages/DashboardPage.dart';
import 'package:namer_app/pages/LoginPage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyAppState extends ChangeNotifier {
  var loginReqBody = <String, String>{};
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'B-Smart Academia',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: const LoginPage(),
        // home: Dashboardpage(
        //     student: GetSDetail(
        //         sFullName: 'Amaye Kadima',
        //         className: 'FORM FOUR',
        //         sectionName: 'A',
        //         acadYear: '2023-2024')),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/studentAccountPage':
              return parseStudentAccountPageRoute(settings);
            case '/addStudentAccountPage':
              return parseAddStudentAccountPageRoute(settings);
            case '/dashboardPage':
              return parseDashboardPageRoute(settings);
            default:
              return null;
          }
        },
      ),
    );
  }
}
