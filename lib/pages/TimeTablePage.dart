import 'package:flutter/material.dart';
import 'package:namer_app/core/entities/GetSDetail.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({super.key, required this.student});
  final GetSDetail student;

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  void _popNavigator() {
    Navigator.of(context).pop();
  }

  Widget _timeTableWidget(BuildContext context, BoxConstraints constraints) {
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
                      'Time table',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  ],
                ),
              ),
            ),
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
                    child: const Center(
                      child: Text('Hello world'),
                    )))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LayoutBuilder(
        builder: (context, constraints) =>
            _timeTableWidget(context, constraints));
  }
}
