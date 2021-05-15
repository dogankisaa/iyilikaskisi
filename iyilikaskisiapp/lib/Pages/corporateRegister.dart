import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'corporateLogin.dart';

class CreateCorporateUser extends StatefulWidget {
  final String title;
  CreateCorporateUser({this.title});

  @override
  corporateRegisterScreen createState() => corporateRegisterScreen();
}

// SAYFALARI ÇAĞIRMAK İÇİN KULLANILAN SINIF

class corporateRegisterScreen extends State<CreateCorporateUser> {
  var formKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String downloadUrl;
  String companyName;
  String email;
  String password;
  String adGonder;
  File isyeriResmi;
  TextEditingController t1 = TextEditingController();
TextEditingController t2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(20.0),
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/backGroundIcon.png"),
          fit: BoxFit.cover,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                 SizedBox(height: MediaQuery.of(context).size.height*0.2,),
                  Text(
                        "Kayıt Ol",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.06,),
                  TextFormField(
                    onSaved: (x) {
                      setState(() {
                        companyName = x;
                      });
                    },
                    validator: (x) {
                      if (x.isEmpty) {
                        return "Doldurulması Zorunludur!";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.blue,
                      ),
                      errorStyle: TextStyle(fontSize: 18),
                      labelText: "İşletme Adı",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                 SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  TextFormField(
                    onSaved: (x) {
                      setState(() {
                        email = x;
                      });
                    },
                    validator: (x) {
                      if (x.isEmpty) {
                        return "Doldurulması Zorunludur!";
                      } else {
                        if (EmailValidator.validate(x) != true) {
                          return "Geçerli Bir Email Adresi Giriniz!";
                        } else {
                          return null;
                        }
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.blue,
                      ),
                      errorStyle: TextStyle(fontSize: 18),
                      labelText: "Email",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  TextFormField(
                    controller: t1,
                    onSaved: (x) {
                      setState(() {
                        password = x;
                      });
                    },
                    validator: (x) {
                      if (x.length < 6) {
                        return "6 karakterden uzun bir şifre giriniz!";
                      } else {
                       return null;
                      }
                    },
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.blue,
                      ),
                      errorStyle: TextStyle(fontSize: 18),
                      labelText: "Şifre",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  TextFormField(
                    controller: t2,
                    
                    validator: (x) {
                      if (x.isEmpty) {
                        return "Doldurulması Zorunludur!";
                      } else if(t1.text != t2.text){
                        return "Girdiğiniz Şifreler Eşleşmelidir.";
                      }
                       
                      
                    },
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.blue,
                      ),
                      errorStyle: TextStyle(fontSize: 18),
                      labelText: "Şifre Tekrar",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(height: 30),
                  RaisedButton(
                    onPressed: _emailSifreEkle,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    hoverColor: Colors.black,
                    child: Text(
                      "Kayıt Ol",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                  Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(child: Center(
                              child: RichText(
                                  text: TextSpan(
                                      text: 'Zaten Bir Hesabın Var Mı?',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                      children: <TextSpan>[
                                TextSpan(
                                    text: ' Giriş Yap',
                                    style: TextStyle(
                                        color: Colors.blueAccent[700]),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                            context, "/corporateLoginUser");
                                      }),
                              ]))))
                        ],
                      ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _emailSifreEkle() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      String id = _firestore.collection("company").doc().id;

      FirebaseFirestore.instance.collection('adresses').doc(companyName).set({
       'adres': ''
      });

      FirebaseFirestore.instance.collection("company").doc(email).set({
        'id': id,
        'email': email,
        'companyName': companyName,
        'password': password
      });
      FirebaseFirestore.instance
          .collection("corpCode")
          .doc(companyName)
          .set({'id': id, 'companyName': companyName});
    
      FirebaseFirestore.instance
          .collection(companyName)
          .doc();
  
      var _firebaseUser = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .catchError((onError) => null);
      if (_firebaseUser != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CorporateLoginUser()));

        Alert(
            type: AlertType.success,
            context: context,
            title: "KAYIT EKLENDİ!",
            desc: "Lütfen Email Adresinize Gelen Mesajı Onaylıyınız!",
            buttons: [
              DialogButton(
                child: Text(
                  "KAPAT",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/corporateLoginUser");
                },
              )
            ]).show();
        formKey.currentState.reset();

        _firebaseUser.user
            .sendEmailVerification()
            .then((value) => null)
            .catchError((onError) => null);
      } else {
        Alert(
            type: AlertType.warning,
            context: context,
            title: "KAYIT EKLENEMEDİ!",
            desc:
                "Sisteme Kayıtlı Bir Email Adresi Girdiniz. \n Lütfen Farklı Bir Email Adresi Giriniz!",
            buttons: [
              DialogButton(
                child: Text(
                  "KAPAT",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ]).show();
      }
    }
  }

}
