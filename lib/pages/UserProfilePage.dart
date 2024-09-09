import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:namer_app/core/entities/ParentDetail.dart';
import 'package:namer_app/core/utilities/app_config.dart';
import 'package:namer_app/core/utilities/local_response_model.dart';
import 'package:namer_app/services/api/auth_requests.dart';
import 'package:namer_app/services/shared_prefs_service.dart';

class Userprofilepage extends StatefulWidget {
  final sharedPrefs = SharedPrefsService();

  Userprofilepage({super.key});

  @override
  State<Userprofilepage> createState() => _UserprofilepageState();
}

class _UserprofilepageState extends State<Userprofilepage> {
  late ParentDetail parentDetail;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestParentDetails();
  }

  void _popNavigator() {
    Navigator.of(context).pop();
  }

  Future<Map<String, String?>> _getParentDetailsBody() async {
    final body = {
      'User_Name': await widget.sharedPrefs.readString("User_Name"),
    };
    return body;
  }

  void parseParentDetailsRequest(Iterable response) {
    final statusMessage =
        LocalResponseModel.getErrorStatusFromResponse(response);
    if (statusMessage.toLowerCase() == "UserName not exists") {
      showErrorQuickAlert(context, 'Failed', statusMessage);
    } else {
      parentDetail = ParentDetail.fromJson(response.first);
    }
  }

  void _requestParentDetails() async {
    final navigator = Navigator.of(context);
    var body = await _getParentDetailsBody();
    showFetchingQuickAlert(context, 'Loading...');
    try {
      final response =
          await SchoolDetailsApi.getParentDet.sendRequest(body: body);
      if (navigator.context.mounted) navigator.pop();
      if (response['response'] == null) throw response['message'];
      parseParentDetailsRequest(response['response']);
    } catch (e) {
      showErrorQuickAlert(navigator.context, 'Failed', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bg-2.png'), fit: BoxFit.cover)),
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
                      'Edit Profile',
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
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      const Row(
                        children: [Text('Contact Information')],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).colorScheme.secondary,
                                spreadRadius: 1),
                          ],
                        ),
                        height: 50,
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Name:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(parentDetail.parentName!)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Container(decoration: const,child: Column(children: [
                      //   Row(children: [Text('Name')])
                      // ]),)
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      );
    });
  }
}
