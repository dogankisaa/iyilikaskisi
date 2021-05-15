import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/text.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kartal/kartal.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';

import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

class DonateConfirm extends StatefulWidget {
  String id;
  String title;

  String companyName1;
  DonateConfirm(
      {this.id, this.title, this.companyName1});

  @override
  makeDonateConfirmScreen createState() => makeDonateConfirmScreen();
}

TextEditingController t1 = TextEditingController();
var formKey = GlobalKey<FormState>();
class makeDonateConfirmScreen extends State<DonateConfirm> {
  var formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  String userCode1;
  String compCode;
  String corporateId;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {

    });
    _selectedIndex = index;
    if (_selectedIndex == 0) {
      bottomBarAra();
    }
    if (_selectedIndex == 1) {
      bottomBarHome();
    }
    if (_selectedIndex == 2) {
      bottomBarBagis();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(

        constraints: BoxConstraints.expand(),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Form(
              key: formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.07)),
                alignment: Alignment.bottomCenter,
                child: Column(

                  children: <Widget>[
                    Row(
                      children: [
                        Container(
                          height: 69,
                          width: 69,
                          child: Image(image: AssetImage('assets/agreement.png')),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.07,),
                        Expanded(
                          child: Text(
                            "Askıdan ürün alabilmek için, ürünün bulunduğu iş yerinin İyilik Askısı hesabında beliren kodu giriniz.",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10),
                    TextFormField(
                      validator: (x) {
                          if (x.isEmpty) {
                            return "Doldurulması Zorunludur!";
                          } else if(t1.text != compCode){
                            return "Lütfen Geçerli Bir Onay Kodu Giriniz!";
                          }
                        },
                      controller: t1,
                      onSaved: (x) {
                        setState(() {
                          userCode1 = x;
                        });
                      },
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 50, color: Colors.grey),
                      obscureText: false,
                      decoration: InputDecoration(
                          hintText: "Kod",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 50,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            kodDenetim();
                          },
                          color: Colors.blue[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          hoverColor: Colors.black,
                          child: Text(
                            "Onayla",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
            ),
            new Container(
              height: context.dynamicHeight(0.14),
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),

              child: BottomNavigationBar(


                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 40,
                    ),
                    label: "Ara",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,

                      size: 40,
                    ),
                    label: 'Ana Sayfa',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add,
                      size: 40,
                    ),
                    label: "Bağış yap",
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.grey,
                unselectedItemColor: Colors.grey,
                onTap: _onItemTapped,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bottomBarBagis() {
    Navigator.pushNamed(context, "/makeDonateCorp");
  }

  bottomBarAra() {
    Navigator.pushNamed(context, "/search");
  }

  bottomBarHome() {
    Navigator.pushNamed(context, "/donatePage");
  }

  kodDenetim() {
    CollectionReference users = FirebaseFirestore.instance.collection('products');

    FirebaseFirestore.instance
        .collection('corpCode')
        .doc(widget.companyName1)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> firestoreInfo = documentSnapshot.data();

      setState(() {
        compCode = firestoreInfo['kod'];
      });
    });
    if (compCode == t1.text) {
      users
          .doc(widget.id)
          .delete();
          

          Alert(
            type: AlertType.success,
            context: context,
            title: "Başarılı!",
            desc: "Ürünü Askıdan Başarılı Bir Şekile Aldınız!",
            buttons: [
              DialogButton(
                  child: Text(
                    "Kapat",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/donatePage");
                  }),
            ]).show();
          
    }

  }


}
