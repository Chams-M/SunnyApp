import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginov_tasks/classes/dropdown.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class Expenses extends StatefulWidget {
  final User user;

  const Expenses({required this.user});

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  late User _currentUser;
  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  File? file;
  UploadTask? task;

  final GlobalKey<FormState> _formKey = GlobalKey<
      FormState>(); // ! This uniquely identifies the Form, and allows validation of the form in a later step.
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const kDarkBlueColor = Color(0xff424F6A);
    final fileName = file != null ? basename(file!.path) : 'No File Selected ';

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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
              child: Column(children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Select your expenses file to be send to the HR department',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),

                //TODO : keyboard shows numbers only for amount field


                InputTitle(
                  title: 'Amount :',
                  child: SuffixedTextField(
                    hint: 'set the amount',
                    controller: amountController,
                    suffix: Icon(Icons.attach_money_rounded),
                  ),
                ),
                SizedBox(height: 40.0),
                InputTitle(
                  title: 'Description :',
                  child: SuffixedTextField(
                    hint: 'something to tell',
                    controller: descController,
                    suffix: Icon(Icons.description),
                  ),
                ),
                SizedBox(height: 40.0),
              ]),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('Attach a file'),
                      Container(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: kDarkBlueColor,
                                // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                textStyle: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                            onPressed: selectFile,
                            child: Icon(
                              Icons.attach_file,
                              color: Colors.white70,
                            )),
                      ),
                      Text(fileName),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [
                      Text('Upload the file'),
                      Container(
                          width: 150,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green.withOpacity(0.7),
                              ),
                              onPressed: uploadFile,
                              child: Icon(Icons.upload_file,
                                  color: Colors.white70))),
                      SizedBox(
                        height: 16.0,
                      )
                    ],
                  ),
                  task != null
                      ? buildUploadStatus(task!)
                      : Container(), //not seen unless upload button is clicked
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

//***********create document to firebase **********
  // TODO : check if fields aren't empty before uploading


  Future<void> imageSetup(String? url, String? amount, String? desc) async {
    {
      CollectionReference images = FirebaseFirestore.instance
          .collection('images')
          .doc('${_currentUser.uid}')
          .collection('user_images');
      images.add({'url': url, 'description': desc, 'amount': amount});
      return;
    }
  }



//TODO:upload from camera



//***********choose the file from phone system

  Future selectFile() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: false); // only 1 file allowed to be picked
    if (result == null) return;
    final path = result.files.single.path!; // fileName
    setState(() {
      file = File(path);
    });
  }

//********uploading file to Firebase Storage********
 
  Future uploadFile() async {
    if (file == null) return; // nothing working
    final fileName = basename(file!.path);
    final destination = 'files/$fileName'; // file future place in Firebase
    task = FirebaseApi.uploadFile(destination, file!); //class FirebaseApi
    setState(() {});

    if (task == null) return; // didn't uploaded
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    //********adding file to the user document reference in Firestore********
    imageSetup(urlDownload, amountController.text, descController.text);

    // print('Download URL : $urlDownload');

    // ********reset everything after successfullyyyyyy uploading********
    setState(() {
      amountController.clear();
      descController.clear();
      task = null;
      file = null;
    });
  }

// ********widget of the percentage while uploading********

  Widget buildUploadStatus(UploadTask uploadTask) =>
      StreamBuilder<TaskSnapshot>(
        stream: task?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);
            return Text('$percentage%');
          } else {
            return Container();
          }
        },
      );
}

// ********adding file to Firebase Storage********
class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
