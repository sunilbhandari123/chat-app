import 'package:fchat/r_button.dart';
import 'package:fchat/screens/loginscreen.dart';
import 'package:fchat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  // Animation

  late AnimationController controller;
  late Animation animation;

  get status => null;
  @override
  void initState() {
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    //animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    //animation.addStatusListener((status) {
    //if (status == AnimationStatus.completed) {
    //controller.reverse(from: 1.0);
    //} else if (status == AnimationStatus.dismissed) {
    //controller.forward();
    //}
    //});
    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                AnimatedTextKit(animatedTexts: [
                  TypewriterAnimatedText(' Chat App',
                      textStyle: const TextStyle(
                        fontSize: 40.0,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w900,
                      )),
                ]),
              ],
            ),

            const SizedBox(
              height: 48.0,
            ),

            Rounded(title: 'Log In',colour: Colors.purpleAccent,onPressed:(){
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginScreen()));
          },),


          const SizedBox(height: 10,),
          Rounded(
              title: 'Register',
              colour: Colors.greenAccent,
              onPressed: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => RegistrationScreen()));
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
