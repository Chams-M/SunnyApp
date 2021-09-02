import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class LegalDocs extends StatefulWidget {
  final User user;

  const LegalDocs({required this.user});
  @override
  _LegalDocsState createState() => _LegalDocsState();
}

class _LegalDocsState extends State<LegalDocs> {
  late List _myActivities;
  final formKey = new GlobalKey<FormState>();
  late User _currentUser;
  bool isPressed = false;
  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
    _myActivities = [];
  }

  String? dropdownvalue;
  @override
  Widget build(BuildContext context) {
    const kDarkBlueColor = Color(0xff424F6A);
    return Scaffold(
      body: Container(
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Text(
                'Select the documents to be requested from the HR department',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Center(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16),
                      child: MultiSelectFormField(
                        autovalidate: false,
                        chipBackGroundColor: Colors.blue,
                        chipLabelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                        checkBoxActiveColor: Colors.blue,
                        checkBoxCheckColor: Colors.white,
                        dialogShapeBorder: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        title: Text(
                          "Legal Documents",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.length == 0 ||
                              isPressed == true) {
                            return 'Please select one or more options';
                          }
                          return null;
                        },
                        dataSource: [
                          {
                            "display": "Attestation of employment",
                            "value": "Attestation of employment",
                          },
                          {
                            "display": "Attestation of salary",
                            "value": "Attestation of salary",
                          },
                          {
                            "display": "Payslip",
                            "value": "Payslip",
                          },
                        ],
                        textField: 'display',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'CANCEL',
                        hintWidget: Text('Please choose one or more'),
                        initialValue: _myActivities,
                        onSaved: (value) {
                          if (value == null) return;
                          setState(() {
                            _myActivities = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: 80,
                      height: 40,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: kDarkBlueColor,
                          ),
                          onPressed: () {
                            setState(() {
                              isPressed = true;
                            });
                            sendRequest(_myActivities);
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white70,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendRequest(List<dynamic> _myActivities) {
    //toList();
    FirebaseFirestore.instance
        .collection('Docs_Requests')
        .doc('${_currentUser.uid}')
        .set({
      'applicant': _currentUser.uid,
      'applicant_email': _currentUser.email,
      'requested_docs': _myActivities,
    });
    showDialog(
        barrierDismissible:
            false, // * showdialog can be closed only on clicking on the action
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Done"),
            content: Text(
                "Your request for $_myActivities has been sent successfully . "),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  setState(() {
                    _myActivities.clear();
                  });
                  Navigator.of(context).pop();

                },
              )
            ],
          );
        });
  }
}
