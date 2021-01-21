import 'package:flutter/material.dart';
import 'package:profile/profile_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _passwordTextContoller = TextEditingController();
  final _emailTextController = TextEditingController();
  final _usernameTextController = TextEditingController();

  double _formProgress = 0;

  SharedPreferences logindata;
  bool newuser;

  void initState() {
    super.initState();
    check_if_already_login();
  }

  // ignore: non_constant_identifier_names
  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);

    print(newuser);
    if (newuser == false) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => ProfileCard()));
    }
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    _passwordTextContoller.dispose();
    _emailTextController.dispose();
    _usernameTextController.dispose();
    super.dispose();
  }

  void _updateFormProgress() {
    var progress = 0.0;
    var controllers = [
      _passwordTextContoller,
      _emailTextController,
      _usernameTextController
    ];

    for (var controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress),
          Text('Sign up', style: Theme.of(context).textTheme.headline4),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: InputDecoration(hintText: 'Username'),
              validator: (value) {
                if (value.isEmpty) return 'Enter a username';
                Pattern pattern =
                    r"^(?=.{8,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$";
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(value))
                  return 'Invalid username!';
                else
                  return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _emailTextController,
              decoration: InputDecoration(hintText: 'Email'),
              validator: (value) {
                if (value.isEmpty) return 'Enter a email';
                Pattern pattern =
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(value))
                  return 'Invalid email!';
                else
                  return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _passwordTextContoller,
              decoration: InputDecoration(hintText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) return 'Enter a password';
                Pattern pattern =
                    r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(value))
                  return 'Invalid password';
                else
                  return null;
              },
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor:
                  MaterialStateColor.resolveWith((Set<MaterialState> states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.white;
              }),
              backgroundColor:
                  MaterialStateColor.resolveWith((Set<MaterialState> states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.blue;
              }),
            ),
            onPressed: () {
              String email = _emailTextController.text;
              String password = _passwordTextContoller.text;
              String username = _usernameTextController.text;
              int currentscore = 0;

              // _formProgress == 1 ? _showWelcomeScreen : null;
              // Validate returns true if the form is valid, otherwise false.
              if (_formKey.currentState.validate()) {
                logindata.setBool('login', false);
                logindata.setString('email', email);
                logindata.setString('username', username);
                logindata.setInt('current_score', currentscore);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileCard(),
                  ),
                );
                // Scaffold.of(context)
                //     .showSnackBar(SnackBar(content: Text('Processing Data')));
              }
            },
            child: Text('Sign up'),
          ),
        ],
      ),
    );
  }
}

class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  AnimatedProgressIndicator({
    @required this.value,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _colorAnimation;
  Animation<double> _curveAnimation;

  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);

    var colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value.withOpacity(0.4),
      ),
    );
  }
}
