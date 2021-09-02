import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:diginov_tasks/classes/clocker.dart';

class Time extends StatefulWidget {
  final User user;

  const Time({required this.user});

  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time> {
  late User _currentUser;
  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        margin: EdgeInsets.all(10),
        child: Center(
          child: ClockWidget(user: _currentUser),
        ),
      ),
    );
  }
}
