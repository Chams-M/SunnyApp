import 'package:diginov_tasks/screens/expenses.dart';
import 'package:diginov_tasks/screens/leave_requests.dart';
import 'package:diginov_tasks/screens/legal_docs.dart';
import 'package:diginov_tasks/screens/navigationdrawer.dart';
import 'package:diginov_tasks/screens/time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _currentUser;
  int selectedIndex = 0;

// ************** to display in the appbar and bottom navigation bar***************
  final List<String> label = [
    'Time',
    'Leave Requests',
    'Expenses',
    'Legal Docs'
  ];

  PageController _pageController =
      PageController(initialPage: 0); //* for controlling swapping

  final PageStorageBucket bucket = PageStorageBucket();

  //**********take the current user uid************

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white70),
        backgroundColor: Colors.green,
        title: Text(
          label[selectedIndex],
          style: TextStyle(color: Colors.white70),
        ),
      ),
      drawer: NavigationDrawerWidget(_currentUser), 
      bottomNavigationBar: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: 60,
          child: BottomNavigationBar(
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey[500],
            currentIndex: selectedIndex,
            onTap: (value) {
              selectedIndex = value;
              _pageController.animateToPage(
                value,
                duration: Duration(milliseconds: 200),
                curve: Curves.linear,
              );

              //setState(() {});
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time_filled_sharp),
                label: (label[selectedIndex]),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.near_me_rounded),
                label: (label[selectedIndex]),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money_rounded),
                label: (label[selectedIndex]),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.article_rounded),
                label: (label[selectedIndex]),
              ),
            ],
          ),
        ),
      ),
      //******* swapping between screens
      body: PageView(
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              selectedIndex =
                  page; //* to change navbar item too along with the screen
            });
          },
          children: [
            Time(user: _currentUser),
            LeaveRq(
              user: _currentUser,
            ),
            Expenses(
              user: _currentUser,
            ),
            LegalDocs(
              user: _currentUser,
            )
          ]),
    );
  }
}
