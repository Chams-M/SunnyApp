// ! I recommend you to install these extensions if they aren't already installed 
// ! Better Comments / Error Lens / Bracket Pair colorizer

import 'package:Sunny/screens/login.dart';
import 'package:Sunny/src/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'routes.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginPage.routeName,
      routes: routes,
      title: 'Flutter Authentication',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
    );
  }
}
