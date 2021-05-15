import 'dart:ui';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:kartal/kartal.dart';
import 'package:flutter/material.dart';

import 'package:random_string/random_string.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class CorporateCode extends StatefulWidget {
  final String title;
  TextEditingController t1 = TextEditingController();
  String email;

  CorporateCode({this.title, this.email});

  @override
  corporateScreen createState() => corporateScreen();
}

// SAYFALARI ÇAĞIRMAK İÇİN KULLANILAN SINIF

class corporateScreen extends State<CorporateCode> {
  TextStyle text = TextStyle(fontSize: 30);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController t1 = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  var formKey = GlobalKey<FormState>();
  String indirmeBagglantisi;
  File yuklenecekDosya;
  String corporateCode1;
  String cn;
  String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      urunEkle();
    }
    if (_selectedIndex == 1) {
      kodAll();
    }
    if (_selectedIndex == 2) {
      adresEkle();
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
    return Scaffold(
      primary: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            color: Colors.blue,
            icon: Icon(
              Icons.exit_to_app,
              size: 32,
              color: Colors.white,
            ),
            onPressed: _userCikis,
          )
        ],
        title: Text("Doğrulama Kodu"),
      ),
      resizeToAvoidBottomInset: false,
      body: Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Form(
                  key: formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: context.dynamicHeight(0.03)),
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: t1,
                          onSaved: (x) {
                            setState(() {
                              corporateCode1 = x;
                            });
                          },
                          enabled: false,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.black,
                          ),
                          obscureText: false,
                          decoration: InputDecoration(
                              hintText: "Kod Oluştur",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 50,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                        ),
                         SizedBox(height: context.dynamicHeight(0.001),),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                          
                            RaisedButton(
                              onPressed: () {
                                kodAl();
                              },
                              color: Colors.blue[500],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 30),
                              hoverColor: Colors.black,
                              child: Text(
                                "Kod Oluştur",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              ),
                            ),
                            SizedBox(
                              height: context.dynamicHeight(0.3),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 100),
              new Container(
                  height: 100,
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                 
                    child: BottomNavigationBar(
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 40,
                          ),
                          label: "Ürün Ekle",
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.home,
                            color: Colors.grey,
                            size: 40,
                          ),
                          label: 'Ana Sayfa',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.place,
                            size: 40,
                          ),
                          label: "Adres Güncelle",
                        ),
                      ],
                      currentIndex: _selectedIndex,
                      selectedItemColor: Colors.grey,
                      unselectedItemColor: Colors.grey,
                      onTap: _onItemTapped,
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }

  void _userCikis() async {
    await _auth
        .signOut()
        .then((value) => Navigator.pushNamed(context, "/"))
        .catchError((onError) {
      Alert(
          type: AlertType.warning,
          context: context,
          title: "ÇIKIŞ YAPILAMADI!",
          buttons: [
            DialogButton(
              child: Text(
                "KAPAT",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ]).show();
    });
  }

  void kodAl() {
    FirebaseFirestore.instance
        .collection('company')
        .doc(_auth.currentUser.email)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> firestoreInfo = documentSnapshot.data();

      setState(() {
        cn = firestoreInfo['companyName'];

        FirebaseFirestore.instance
            .collection("corpCode")
            .doc(cn)
            .update({'kod': t1.text = randomAlphaNumeric(6)});
      });
    });
  }

  urunEkle() {
    Navigator.pushNamed(context, "/addProduct");
  }

  adresEkle() {
    Navigator.pushNamed(context, "/addAdress");
  }

  kodAll() {
    Navigator.pushNamed(context, "/corporateCode");
  }

 
}
