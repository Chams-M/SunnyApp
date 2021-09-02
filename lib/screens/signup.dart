import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginov_tasks/classes/fire_auth.dart';
import 'package:diginov_tasks/classes/validator.dart';
import 'package:diginov_tasks/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../classes/greenclipper.dart';

class SignupPage extends StatefulWidget {
  static var routeName = '/SignupPage';
  // final String title = 'Registration';

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // ! Future is used to represent a potential value or error that will be available at some time in the future.
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            user: user,
          ),
        ),
      );
    }
    return firebaseApp;
  }

  bool isHidden = true;

  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: true,
      body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipPath(
                      clipper: GreenClipper(),
                      child: Container(
                        color: Colors.green.withOpacity(0.7),
                        height: 150,
                      ),
                    ),
                    Container(
                      child: Stack(children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Create',
                            style: TextStyle(
                                fontSize: 55.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0, 60.0, 0.0, 0.0),
                          child: Text(
                            'Account',
                            style: TextStyle(
                                fontSize: 55.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(205.0, 40.0, 0.0, 0.0),
                          child: Text(
                            '.',
                            style: TextStyle(
                                fontSize: 80.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
                      child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          shadowColor: Colors.white54,
                          color: Colors.white.withOpacity(0.7),
                          elevation: 7.0,
                          child: Column(
                            children: [
                              Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                          controller: nameController,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.person),
                                            hintText: 'NAME',
                                            hintStyle: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.green)),
                                          ),
                                          validator: (value) =>
                                              Validator.validateName(
                                                  name: value!)),
                                      SizedBox(height: 20.0),
                                      TextFormField(
                                          controller: emailController,
                                          decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.email),
                                              labelText: 'EMAIL',
                                              labelStyle: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.green))),
                                          validator: (value) =>
                                              Validator.validateEmail(
                                                  email: value!)),
                                      SizedBox(height: 20.0),
                                      TextFormField(
                                          controller: passwordController,
                                          obscureText: isHidden,
                                          decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.lock),
                                              suffix: InkWell(
                                                onTap: _togglePasswordView,
                                                child: Icon(
                                                  isHidden
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                ),
                                              ),
                                              labelText: 'PASSWORD ',
                                              labelStyle: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.green))),
                                          validator: (value) =>
                                              Validator.validatePassword(
                                                  password: value!)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 50.0),
                              Container(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 10.0),
                                height: 50.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(10.0),
                                  shadowColor: Colors.greenAccent,
                                  color: Colors.green.withOpacity(0.7),
                                  elevation: 7.0,
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (_formKey.currentState!.validate()) {
                                        User? user = await FireAuth
                                            .registerUsingEmailPassword(
                                                name: nameController.text,
                                                email: emailController.text,
                                                password:
                                                    passwordController.text,
                                                context: context);
                                        // * adding user data to a document in Firestore
                                        userSetup(
                                            nameController.text,
                                            emailController.text,
                                            passwordController
                                                .text); // * sending user data to Firestore
                                        if (user != null) {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfilePage(user: user)),
                                          );
                                        }
                                      }
                                    },
                                    child: Center(
                                      child: Text(
                                        'SIGNUP',
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
                          )),
                    ),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return MediaQuery(
                  data: new MediaQueryData(), child: Text('errreur '));
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  void _togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  Future<void> userSetup(
      String? displayName, String? email, String? password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    // ! if this method is called when signing up
    CollectionReference users = FirebaseFirestore.instance
        .collection('utilisateurs'); // * getting the collection ref
    Future<DocumentReference> doc = users.add({
      'displayName': displayName,
      'email': email,
      'password': password,
      'uid': uid
    }); // adding data
    Future<String?> docid = doc.then((value) {
      String docid = value.id;
      print('**********************************${value.id}');
      return docid;
    });
    return;
  }
}
