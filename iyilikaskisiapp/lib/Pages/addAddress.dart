import 'package:firebase_auth/firebase_auth.dart';
import 'package:iyilikaskisiapp/Pages/corporateCode.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

class AddAdress extends StatefulWidget {
  final String title;
  AddAdress({this.title});

  @override
  _addAdress createState() => _addAdress();
}

class _addAdress extends State<AddAdress> {
  var formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController t2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String cn;
  String ad;
  String adres;

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
      adresEklee();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("İşletme Adresi"),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.06),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Row(
                      children: [
                        Image(image: AssetImage('assets/corps.png')),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.07,
                        ),
                        Expanded(
                          child: Text(
                            "Adresinizi güncel tutarak işletmenizi ulaşılabilir kılın.",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(itemBuilder: (BuildContext context, int index) {  },
                      
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    TextFormField(
                      controller: t2,
                      onSaved: (x) {
                        setState(() {
                          adres = x;
                        });
                      },
                      validator: (x) {
                        if (x.isEmpty) {
                          return 'Bu alan Boş Bırakılamaz!';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.comment_bank_outlined,
                          color: Colors.blue,
                        ),
                        errorStyle: TextStyle(fontSize: 18),
                        labelText: "İşletme Adresiniz",
                        labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(height: 30),
                    RaisedButton(
                      onPressed: adresEkle,
                      color: Colors.blue,
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
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            new Container(
                height: MediaQuery.of(context).size.height * 0.15,
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
               
                  child: BottomNavigationBar(
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.add,
                          size: 40,
                        ),
                        label: "Ürün Ekle",
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
                ),
          ],
        ),
      ),
    );
  }

  void adresEkle() {
    if (_formKey.currentState.validate()) {
      FirebaseFirestore.instance
          .collection('company')
          .doc(_auth.currentUser.email)
          .get()
          .then((value) {
        setState(() {
          FirebaseFirestore.instance
              .collection('adresses')
              .doc(value.data()['companyName'])
              .set({'adres': t2.text});
        });
      });

      Alert(
          type: AlertType.success,
          context: context,
          title: "ADRES GÜNCELLENDİ",
          desc: "Adresiniz Başarıyla Güncellendi",
          buttons: [
            DialogButton(
              child: Text(
                "KAPAT",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CorporateCode())),
            )
          ]).show();
    } else {
      return null;
    }
  }

  urunEkle() {
    Navigator.pushNamed(context, "/addProduct");
  }

  adresEklee() {
    Navigator.pushNamed(context, "/addAdress");
  }

  kodAll() {
    Navigator.pushNamed(context, "/corporateCode");
  }
}
