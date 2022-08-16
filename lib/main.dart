import 'package:fchat/screens/chatscreen.dart';
import 'package:fchat/screens/loginscreen.dart';
import 'package:fchat/screens/registration_screen.dart';
import 'package:fchat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';


void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes:{
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id:(context)=>  LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
