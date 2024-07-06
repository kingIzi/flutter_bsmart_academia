import 'package:flutter/material.dart';
import 'package:namer_app/core/entities/GetSDetail.dart';
import 'package:namer_app/core/utilities/app_config.dart';
import 'package:namer_app/pages/AddStudentAccountPage.dart';
import 'package:namer_app/pages/DashboardPage.dart';
import 'package:namer_app/pages/StudentAccountPage.dart';

Route getAddStudentAccountPageRoute(
    Offset begin, Offset end, CurveTween curveTween) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const Addstudentaccountpage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          simpleSlideRouteTransition(
              context,
              animation,
              secondaryAnimation,
              child,
              // const Offset(0.0, 1.0),
              // Offset.zero,
              // CurveTween(curve: Curves.easeIn)
              begin,
              end,
              curveTween));
}

MaterialPageRoute parseStudentAccountPageRoute(RouteSettings settings) {
  final args = settings.arguments as Map<String, dynamic>;
  final students = args['students'] as List<GetSDetail>;
  //final studentAccountsPage = studentAccountsPageRoute(students);
  return MaterialPageRoute(
    builder: (context) {
      return StudentAccountPage(students: students);
    },
  );
}

MaterialPageRoute parseAddStudentAccountPageRoute(RouteSettings settings) {
  return MaterialPageRoute(builder: (context) {
    return const Addstudentaccountpage();
  });
}

MaterialPageRoute parseDashboardPageRoute(RouteSettings settings) {
  final args = settings.arguments as Map<String, dynamic>;
  final student = args['student'] as GetSDetail;
  return MaterialPageRoute(builder: (context) {
    return Dashboardpage(
      student: student,
    );
  });
}
