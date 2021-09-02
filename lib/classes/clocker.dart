import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

// ! issue : checkin and checkout setstate while swapping to another screen 
class ClockWidget extends StatefulWidget {
  final User user;

  const ClockWidget({required this.user});
  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  late User _currentUser;
  bool _hasBeenPressed = false;
  bool checkedIn = false;
  var _firstPressb1 = true;
  var _firstPressb2 = true;
  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var hour = int.parse(DateFormat.H().format(DateTime.now()));
    String greeting;
    if (hour >= 5 && hour < 12) {
      greeting = "Morning";
    } else if (hour >= 12 && hour < 17) {
      greeting = "Afternoon";
    } else
      greeting = "Evening";
    var date = DateFormat.yMMMEd().format(DateTime.now());
    var time = DateFormat.Hms().format(DateTime.now());
    return TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
      return Container(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
            Text(
              "$date",
              style: TextStyle(
                  color: Colors.deepOrange[200],
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "${DateFormat.Hms().format(DateTime.now())}",
              style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 70.0,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Good $greeting ${_currentUser.displayName}",
              style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: _hasBeenPressed
                                ? Colors.deepOrange[50]
                                : Colors.deepOrange[100],
                          ),
                          onPressed: () async {
                            // *  onPressed function will only respond to the elevatedButton's first click.
                            if (_firstPressb1) {
                              _firstPressb1 = false;
                              setState(() {
                                _hasBeenPressed = !_hasBeenPressed;
                                checkedIn = !checkedIn;
                                timeSetup(null, time, date);
                              });
                            }
                          },
                          child: Icon(
                            Icons.fingerprint_rounded,
                            color: Colors.white70,
                            size: 60,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Check Out",
                        style: TextStyle(
                            color: _hasBeenPressed
                                ? Colors.grey[500]
                                : Colors.deepOrange[100],
                            //fontSize: 20.0,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: _hasBeenPressed
                                ? Colors.green[400]
                                : Colors.green[50],
                          ),
                          onPressed: () async {
                            if (_firstPressb2) {
                              _firstPressb2 = false;
                              _hasBeenPressed = true;
                              setState(() {
                                checkedIn = !checkedIn;
                                timeSetup(time, null, date);
                              });
                            }
                          },
                          child: Icon(Icons.fingerprint_rounded,
                              color: Colors.white70, size: 60)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Check In",
                        style: TextStyle(
                            color: _hasBeenPressed
                                ? Colors.green[400]
                                : Colors.grey[500],
                            //fontSize: 20.0,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            _hasBeenPressed == false
                ? Text('no check')
                : Text('Check In at $time'),
          ],
        ),
      );
    });
  }

//***************************************** */

  Future<void> timeSetup(var timeIn, var timeOut, var date) async {
    {
      if (timeIn != null) {
        FirebaseFirestore.instance
            .collection('pointage')
            .doc('${_currentUser.uid}')
            .set({'check-in': timeIn, 'check-out': timeIn, 'date': date});
        showDialog(
            barrierDismissible:
                false, // * showdialog can be closed only on clicking on the action
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Check-in"),
                content: Text("You had successfully checked-in"),
                actions: [
                  TextButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop(); // * closing showdialog widget
                    },
                  )
                ],
              );
            });
      }
      if (timeOut != null) {
        FirebaseFirestore.instance
            .collection('pointage')
            .doc('${_currentUser.uid}')
            .update({'check-out': timeOut}); // * updating checkout
        showDialog(
            barrierDismissible:
                false, // * showdialog can be closed only on clicking on the action
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Check-out"),
                content: Text("You had successfully checked-out"),
                actions: [
                  TextButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop(); 
                    },
                  )
                ],
              );
            });
      }
      return;
    }
  }
}
