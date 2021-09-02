import 'package:diginov_tasks/classes/fire_auth.dart';
import 'package:diginov_tasks/classes/validator.dart';
import 'package:diginov_tasks/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../classes/greenclipper.dart';
import 'signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  static var routeName = '/loginpage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // * initializing firebase
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isHidden = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                      //add wavy
                      ClipPath(
                        clipper: GreenClipper(),
                        child: Container(
                          color: Colors.green.withOpacity(0.7),
                          height: 150,
                        ),
                      ),

                      Stack(children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Welcome',
                            style: TextStyle(
                                fontSize: 60.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0, 60.0, 0.0, 0.0),
                          child: Text(
                            'Back',
                            style: TextStyle(
                                fontSize: 60.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(140.0, 40.0, 0.0, 0.0),
                          child: Text(
                            '.',
                            style: TextStyle(
                                fontSize: 80.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                        ),
                      ]),

                      Container(
                        padding: EdgeInsets.only(
                            top: 30.0, left: 20.0, right: 20.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          shadowColor: Colors.white54,
                          color: Colors.white.withOpacity(0.7),
                          elevation: 7.0,
                          child: Column(children: <Widget>[
                            Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      validator: (value) =>
                                          Validator.validateEmail(
                                              email:
                                                  value!), // class validator.dart
                                      controller: emailController,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.email),
                                          hintText: ' EMAIL',
                                          hintStyle: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green))),
                                    ),
                                    SizedBox(height: 20.0),
                                    TextFormField(
                                      validator: (value) =>
                                          Validator.validatePassword(
                                              password: value!),
                                      controller: passwordController,
                                      obscureText: isHidden,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock),
                                          suffixIcon: IconButton(
                                            icon: Icon(isHidden
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                            onPressed:
                                                _togglePasswordView, // * to show password
                                                // ! issue :  LoginPage widget setstate when icon is pressed
                                          ),
                                          hintText: ' PASSWORD ',
                                          hintStyle: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green))),
                                    ),
                                    SizedBox(height: 10.0),
                                    /*  Container(
                             alignment:Alignment(1.0, 0.0),
                             padding: EdgeInsets.only(top:15.0,left: 200.0,right: 10),
                             child:InkWell(
                               child: Text('Forgot Password ?',
                               style:TextStyle(
                                 color: Colors.green,
                                 fontWeight: FontWeight.bold,
                                 fontFamily: 'Montserrat',
                                 decoration: TextDecoration.underline),
                          
                                 )
                               )
                             ),*/
                                    SizedBox(height: 20.0),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),

                      SizedBox(height: 50.0),
                      Container(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        height: 50.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green.withOpacity(0.7),
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                // class fire_auth.dart
                                User? user =
                                    await FireAuth.signInUsingEmailPassword(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        context: context);

                                if (user != null) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfilePage(user: user)));
                                }
                              }
                            },
                            child: Center(
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New to DigiHora ?',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          SizedBox(width: 5.0),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, SignupPage.routeName);
                            },
                            child: Text('Register',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              // ! not connected
              if (snapshot.hasError) {
                return MediaQuery(
                    data: new MediaQueryData(), child: Text('errreur '));
              }
              //! unless wait till get connected
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

  void _togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }
}
