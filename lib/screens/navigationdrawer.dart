import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'login.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final User _currentUser;
  const NavigationDrawerWidget(User this._currentUser, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    var padding = MediaQuery.of(context).padding;
    double height = MediaQuery.of(context).size.height;
    double newheight = height - padding.top - padding.bottom;
    return Padding(
      padding: const EdgeInsets.only(top: 23.0),
      child: Drawer(
        child: Material(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                height: newheight,
                child: ListView(
                  children: [
                    DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.black,
                         ),
                        child: Container(
                          child: Column(
                            children: [
                              // TODO: add changes
                              Image.asset(
                                'assets/images/loogo.png',
                                height: 137,
                                width:150,
                                scale: 3,
                              ),
                              
                            ],
                          ),
                        )
                        //Text('${_currentUser.displayName}')
                        ),

                      //TODO : add some UI while clicking
                      
                    CustomListTile(
                        context, Icons.person, 'Profile', Icons.arrow_right,
                        () {
                      print(DateTime.now().millisecondsSinceEpoch);
                    }),
                    CustomListTile(context, Icons.lock_clock, 'Clocker',
                        Icons.arrow_right, () {}),
                    CustomListTile(
                        context, Icons.logout_outlined, 'Logout', null,
                        () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget CustomListTile(BuildContext context, IconData icon, String text,
      IconData? icon2, void Function() ontap) {
    return InkWell(
        splashColor: Colors.green,
        onTap: ontap,
        child: Container(
          padding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 15.0),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
              color: Colors.grey.shade200,
            )),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Icon(
                icon2,
                color: Colors.black,
              )
            ],
          ),
        ));
  }
}
