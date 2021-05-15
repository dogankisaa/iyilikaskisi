import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iyilikaskisiapp/Pages/welcome.dart';

class Splash extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Splash> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 3000), () async {
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => WelcomeUser("/welcomeUser")));
    });
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        constraints: BoxConstraints.expand(),
        child: Center(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage('assets/logom.gif')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
