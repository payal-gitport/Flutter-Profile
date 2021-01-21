import 'package:flutter/material.dart';
import 'package:profile/login_screen.dart';
import 'package:profile/profile_card.dart';
import 'package:profile/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUpScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _storeLoggedInStatus(false);
        },
        child: Icon(Icons.login),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            bool isLoggedIn = await _getLoggedInStatus();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return isLoggedIn ? ProfileCard() : LoginScreen();
                },
              ),
            );
          },
          child: Text('click!'),
        ),
      ),
    );
  }

  // Sets the login status
  void _storeLoggedInStatus(bool isLoggedIn) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isLoggedIn', isLoggedIn);
  }

  // Gets the logged in status
  Future<bool> _getLoggedInStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool('isLoggedIn') ?? false;
  }
}
