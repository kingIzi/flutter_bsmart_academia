import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:namer_app/core/entities/GetSDetail.dart';
import 'package:namer_app/core/utilities/app_config.dart';
import 'package:namer_app/core/utilities/routes.dart';
import 'package:namer_app/pages/AddStudentAccountPage.dart';

class StudentAccountPage extends StatefulWidget {
  const StudentAccountPage({super.key, required this.students});
  final List<GetSDetail> students;
  @override
  State<StudentAccountPage> createState() => _StudentAccountPageState();
}

class _StudentAccountPageState extends State<StudentAccountPage> {
  String _welcomeText() {
    assert(widget.students.isNotEmpty);
    final parent = widget.students.first;
    return 'Welcome Mr/Mrs ${parent.parentName}';
  }

  Widget getStudentsList() {
    if (widget.students.isEmpty) {
      return const Center(
        child: Text('No saved students'),
      );
    } else {
      return StudentSelectionsListView(
        students: widget.students,
        pushDashboardPage: _pushDashboardPage,
      );
    }
  }

  void _pushDashboardPage(int index) {
    Navigator.of(context).pushNamed('/dashboardPage',
        arguments: {'student': widget.students[index]});
  }

  void _pushAddStudentAccountPage(BuildContext context) {
    final addStudentAccountPage = getAddStudentAccountPageRoute(
        const Offset(0.0, 1.0),
        Offset.zero,
        CurveTween(curve: Curves.easeInOut));
    Navigator.of(context).push(addStudentAccountPage);
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
              floatingActionButton: FloatingActionButton(
                onPressed: () => _pushAddStudentAccountPage(context),
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              body: Column(
                children: [
                  SafeArea(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => () {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                }, // needed
                                child: Image.asset(
                                  "images/b-smart-acamedia-logo.png",
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.person),
                                color: Theme.of(context).colorScheme.primary,
                                style: IconButton.styleFrom(
                                    shape: const CircleBorder(),
                                    backgroundColor: Colors.white),
                              )
                            ]),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Text(
                              _welcomeText(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
                  Expanded(
                      child: Container(
                          width: double.maxFinite,
                          //color: Colors.white,
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
                          child: getStudentsList()))
                ],
              )),
        );
      },
    );
  }
}

class StudentSelectionsListView extends StatelessWidget {
  const StudentSelectionsListView(
      {super.key, required this.students, required this.pushDashboardPage});
  final List<GetSDetail> students;
  final Function(int) pushDashboardPage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Pick your child`s account',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        students[index].sFullName ?? '',
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        students[index].facilityName ?? '',
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage(
                            'images/graduation.jpg'), // No matter how big it is, it won't overflow
                      ),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                      onTap: () {
                        pushDashboardPage(index);
                      },
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
