
//*********  All routes will be available here 

import 'package:diginov_tasks/screens/login.dart';
import 'package:flutter/material.dart';

import 'screens/signup.dart';
final Map<String, WidgetBuilder> routes = {
  LoginPage.routeName: (context) => LoginPage(),
  SignupPage.routeName: (context) => SignupPage(),


};
