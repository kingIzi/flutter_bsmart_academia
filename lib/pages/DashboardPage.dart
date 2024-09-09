import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:namer_app/core/entities/GetSDetail.dart';
import 'package:namer_app/core/utilities/routes.dart';
import 'package:namer_app/pages/TimeTablePage.dart';

class Dashboardpage extends StatefulWidget {
  final GetSDetail student;
  const Dashboardpage({super.key, required this.student});
  @override
  State<Dashboardpage> createState() => _DashboardpageState();
}

class _DashboardpageState extends State<Dashboardpage> {
  Expanded getHomeCardItem(Widget child) {
    return Expanded(
        child: SizedBox(
      width: double.maxFinite,
      height: 202,
      //color: Colors.redAccent,
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.teal),
              borderRadius: BorderRadius.circular(10.0)),
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: () {},
            child: child,
          ),
        ),
      ),
    ));
  }

  List<Map<String, dynamic>> getNavItems() {
    return [
      {'icon': Icons.calendar_month, 'label': 'Time table'},
      {'icon': Icons.grade, 'label': 'Result(s)'},
      {'icon': Icons.article, 'label': 'Admission'},
      {'icon': Icons.lock, 'label': 'Change Password'},
      {'icon': Icons.logout, 'label': 'Switch Account'},
    ];
  }

  void _pushTimeTablePage() {
    final timeTablePage = TimeTablePage(student: widget.student);
    final dashboardPage = getGeneralAnimatePageRoute(
        timeTablePage,
        const Offset(1.0, 0.0),
        Offset.zero,
        CurveTween(curve: Curves.easeInOut));
    Navigator.of(context).push(dashboardPage);
  }

  void _navItemClicked(index) {
    switch (index) {
      case 0:
        _pushTimeTablePage();
      default:
        throw UnimplementedError('Module not yet implemented');
    }
  }

  @override
  Widget build(BuildContext context) {
    final navItems = getNavItems();
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/bg-2.png'), fit: BoxFit.cover)),
            child: Stack(children: [
              Align(
                alignment: AlignmentDirectional.topStart, // <-- SEE HERE
                child: SizedBox(
                  width: double.maxFinite,
                  height: 180,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.student.sFullName!,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  height: 18,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(widget.student.className!,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400)),
                                      const VerticalDivider(
                                        width: 12,
                                        thickness: 1,
                                        color: Colors.white,
                                      ),
                                      Text(widget.student.sectionName!,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400))
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 16.0),
                                    child: Text(widget.student.acadYear!,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.teal,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                )
                              ],
                            ),
                            IconButton.outlined(
                              onPressed: () {},
                              icon: const Icon(Icons.person),
                              splashRadius: 24,
                              color: Theme.of(context).colorScheme.primary,
                              style: IconButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: Colors.white,
                              ),
                            )
                          ]),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomStart,
                child: Container(
                  width: double.maxFinite,
                  height: constraints.maxHeight - 180,
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
                ),
              ),
              Positioned(
                  top: 150,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              getHomeCardItem(Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              252, 243, 226, 1),
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      child: const Icon(
                                        Icons.school,
                                        size: 32,
                                        color: Colors.orangeAccent,
                                      ),
                                    ),
                                    const Row(
                                      children: [
                                        Text(
                                          '80.56%',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const Text(
                                      'Attendance',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(119, 119, 119, 1)),
                                    ),
                                  ],
                                ),
                              )),
                              const SizedBox(
                                width: 8,
                              ),
                              getHomeCardItem(Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              255, 216, 255, 1),
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      child: const Icon(
                                        Icons.money,
                                        size: 32,
                                        color: Colors.pinkAccent,
                                      ),
                                    ),
                                    const Row(
                                      children: [
                                        Text(
                                          '1,640,000',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Text(
                                          'TZS',
                                          style: TextStyle(fontSize: 14),
                                        )
                                      ],
                                    ),
                                    const Text(
                                      'Fees due',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(119, 119, 119, 1)),
                                    ),
                                  ],
                                ),
                              ))
                            ],
                          ),
                          Expanded(
                              child: SizedBox(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 16.0, top: 8.0),
                              child: GridView.count(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  children:
                                      List.generate(navItems.length, (index) {
                                    return SizedBox(
                                      width: double.maxFinite,
                                      height: 101,
                                      child: Card(
                                        elevation: 1,
                                        color: const Color.fromRGBO(
                                            230, 240, 240, 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            onTap: () {
                                              _navItemClicked(index);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    navItems[index]['icon'],
                                                    size: 54,
                                                    color: const Color.fromRGBO(
                                                        0, 103, 105, 1),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  Text(
                                                    navItems[index]['label'],
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  })),
                            ),
                          ))
                        ],
                      ),
                    ),
                  ))
            ]),
          );
        },
      ),
    );
  }
}
