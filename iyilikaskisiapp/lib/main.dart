import 'package:flutter/material.dart';
import 'package:iyilikaskisiapp/Pages/addAddress.dart';
import 'package:iyilikaskisiapp/Pages/corporateCode.dart';
import 'package:iyilikaskisiapp/Pages/donate.dart';
import 'package:iyilikaskisiapp/Pages/makeDonateCorp.dart';
import 'package:iyilikaskisiapp/Pages/makeDonate.dart';
import 'package:iyilikaskisiapp/Pages/makeDonateConfirm.dart';
import 'package:iyilikaskisiapp/Pages/register.dart';
import 'package:iyilikaskisiapp/Pages/addProduct.dart';
import 'package:iyilikaskisiapp/Pages/corporateRegister.dart';
import 'package:iyilikaskisiapp/Pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iyilikaskisiapp/Pages/search.dart';
import 'package:iyilikaskisiapp/Pages/splash.dart';
import 'package:iyilikaskisiapp/Pages/welcome.dart';
import 'package:iyilikaskisiapp/Pages/corporateLogin.dart';
import 'package:iyilikaskisiapp/Pages/donateConfirm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String title = "Firebase Auth";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
     
      initialRoute: "/",
      routes: {
        "/": (context) => Splash(),
        "/welcomeUser": (context) => WelcomeUser(title),
        "/loginUser": (context) => LoginUser(title),
        "/corporateLoginUser": (context) => CorporateLoginUser(),
        "/createUser": (context) => CreateUser(title),
        "/createCorporateUser": (context) => CreateCorporateUser(),
        "/donatePage": (context) => DonatePage(title),
        "/corporateCode": (context) => CorporateCode(),
        "/makeDonateConfirmScreen": (context) => MakeDonateConfirm(),
        "/makeDonateScreen": (context) => MakeDonate(title),
        "/donateConfirm": (context) =>DonateConfirm(),
        "/addProduct": (context) =>AddProduct(),
        "/makeDonateCorp": (context) => MakeDonateCorp(title),
        "/addAdress": (context) =>AddAdress(),
        "/search": (context) =>Search(),
      },
    );
  }
}
