import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginov_tasks/classes/dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveRq extends StatefulWidget {
  final User user;
  const LeaveRq({required this.user});

  @override
  _LeaveRqState createState() => _LeaveRqState();
}

class _LeaveRqState extends State<LeaveRq> {
  late User _currentUser;
  var date = DateFormat.yMMMEd().format(DateTime.now());
  final calendarTec = TextEditingController();
  final calendarTec2 = TextEditingController();
  final dropdownTec = TextEditingController();
  final comments = TextEditingController();
  get state => null;
  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputTitle(
                      title: 'Absence Type:',
                      child: TextFieldDropdown(
                        hint: 'Select your absence type',
                        controller: dropdownTec,
                        options: const [
                          'Absence From Work',
                          'Excused Absence',
                          'Sick Time',
                          'Family and Medical Leave',
                          'Appointment',
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    InputTitle(
                      title: 'Start Date :',
                      child: TextFieldCalendar(
                        hint: '$date',
                        controller: calendarTec,
                      ),
                    ),
                    const SizedBox(height: 12),
                    InputTitle(
                      title: 'End Date:',
                      child: TextFieldCalendar(
                        hint: '$date',
                        controller: calendarTec2,
                      ),
                    ),
                    const SizedBox(height: 15),
                    InputTitle(
                        title: 'Your Comments',
                        child: TextFormField(
                          controller: comments,
                          maxLines: 3,
                        )),
                    const SizedBox(height: 60),
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      height: 50.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green.withOpacity(0.7),
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {
                            leaveRequest();
                          },
                          child: Center(
                            child: Text(
                              'VALIDATE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

//********************************* */
// TODO : check if fields aren't empty before validating

  void leaveRequest() {
    FirebaseFirestore.instance
        .collection('Leave_Requests')
        .doc('${_currentUser.uid}')
        .set({
      'employee_name': _currentUser.displayName,
      'absence_type': dropdownTec.text,
      'start_date': calendarTec.text,
      'end_date': calendarTec2.text,
      'comments': comments.text,
    });
    showDialog(
        barrierDismissible:
            false, //showdialog can be closed only on clicking on the action
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Done"),
            content: Text("Your leave request has been sent successfully . "),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  setState(() {
                    dropdownTec.clear();
                    calendarTec2.clear();
                    calendarTec.clear();
                    comments.clear();
                  });
                  Navigator.of(context).pop();
                  // closing showdialog widget
                },
              )
            ],
          );
        });
  }
}
