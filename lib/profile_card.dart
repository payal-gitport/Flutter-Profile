import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:profile/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCard extends StatefulWidget {
  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  int score = 0;
  SharedPreferences logindata;
  String username;
  String email;
  int currentscore;

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username');
      email = logindata.getString('email');
      currentscore = logindata.getInt('currentscore') ?? 0;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('My Profile'),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async {
              logindata.setBool('login', true);
              Navigator.pushReplacement(context,
                  new MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
            // onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentscore += 1;

            logindata.setInt('current_score', currentscore);
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[800],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/dp.jpeg'),
                radius: 40.0,
              ),
            ),
            Divider(
              height: 90.0,
              color: Colors.grey[700],
            ),
            Text(
              'Name',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              '$username',
              style: TextStyle(
                color: Colors.amberAccent[200],
                letterSpacing: 2.0,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              'Current Score',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              '$currentscore',
              style: TextStyle(
                color: Colors.amberAccent[200],
                letterSpacing: 2.0,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                Icon(
                  Icons.email,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  '$email',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 18.0,
                    letterSpacing: 1.0,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // void _storeLoggedInStatus(bool isLoggedIn) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.setBool('isLoggedIn', isLoggedIn);
  // }
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  int counter = 1;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
