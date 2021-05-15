import 'package:firebase_auth/firebase_auth.dart';
import 'package:iyilikaskisiapp/Pages/donate.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class WelcomeUser extends StatefulWidget {
  final String title;
  WelcomeUser(this.title);

  @override
  _WelcomeUser createState() => _WelcomeUser();
}

class _WelcomeUser extends State<WelcomeUser> {
  var formKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  String email;
  String password;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20.0),
          constraints: BoxConstraints.expand(),
          child: Column(


            children: <Widget>[

              Row(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.4),
                Expanded(
                  flex: 10,
                  child: Image(image: AssetImage('assets/acilisResim.jpg')),
                )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.07,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Hesap Seçimi" , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),)

                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Center(
                   child:  RichText(
                       text: TextSpan(
                           text: "Kurumsal ",
                           style: TextStyle(
                               fontWeight: FontWeight.bold,
                               color: Colors.black,
                               fontSize: 17,
                           ),
                           children: <TextSpan>[
                             TextSpan(
                                 text: "ya da ",
                                 style: TextStyle(fontWeight: FontWeight.normal)),
                             TextSpan(
                                 text: "Bireysel ",
                                 style: TextStyle(fontWeight: FontWeight.bold)),
                             TextSpan(
                                 text: "hesabınız ile \n        giriş"
                                     " yaparak iyilik  hareketine \n                      katılabilirsiniz!",
                                 style: TextStyle(fontWeight: FontWeight.normal))
                           ])),
                 )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.1
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/loginUser");
                    },
                    color: Colors.blue[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    hoverColor: Colors.black,
                    child: Text(
                      "Bireysel",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/corporateLoginUser");
                    },
                    color: Colors.blue[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    hoverColor: Colors.black,
                    child: Text(
                      "Kurumsal",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
