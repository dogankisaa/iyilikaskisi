import 'package:firebase_auth/firebase_auth.dart';
import 'package:iyilikaskisiapp/Pages/corporateCode.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/cupertino.dart';



class AddProduct extends StatefulWidget {
  final String title;
  AddProduct({this.title});
  @override
  addProduct createState() => addProduct();
}

class addProduct extends State<AddProduct> {
  var formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String cn;
  String ad;
  String aciklama;

  int isUrun = 0;
  int isAna = 0;
  int isAdres = 0;
  int _selectedIndex = 1;

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
        title: Text("Ürün Ekle"),
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Row(
                      children: [
                        Image(image: AssetImage('assets/products.png')),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.07,
                        ),
                        Expanded(
                          child: Text(
                            "Daha zengin menü, asılan daha çok ürün demektir. Menü her zaman güncel kalmalıdır.",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    SingleChildScrollView(
                      child: TextFormField(
                        controller: t1,
                        onSaved: (x) {
                          setState(() {
                            ad = x;
                          });
                        },
                        validator: (x) {
                          if (x.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.fastfood,
                            color: Colors.blue,
                          ),
                          errorStyle: TextStyle(fontSize: 18),
                          labelText: "Ürün Adı",
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.grey),
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
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    TextFormField(
                      controller: t2,
                      onSaved: (x) {
                        setState(() {
                          aciklama = x;
                        });
                      },
                      validator: (x) {
                        if (x.isEmpty) {
                          return 'Bu alan boş bırakılamaz';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.comment_bank_outlined,
                          color: Colors.blue,
                        ),
                        errorStyle: TextStyle(fontSize: 18),
                        labelText: "Ürün Açıklaması",
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    RaisedButton(
                      onPressed: urunEkle,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      hoverColor: Colors.black,
                      child: Text(
                        "Ürün Ekle",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.12,
            ),
            new Container(
                height: MediaQuery.of(context).size.height * 0.15,
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
                          color: Colors.grey,
                          size: 40,
                        ),
                        label: "Adres Güncelle",
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    unselectedItemColor: Colors.grey,
                    selectedItemColor: Colors.grey,
                    onTap: _onItemTapped,
                  ),
                ),
          ],
        ),
      ),
    );
  }

  urunEklee() {
    Navigator.pushNamed(context, "/addProduct");
  }

  adresEklee() {
    Navigator.pushNamed(context, "/addAdress");
  }

  kodAll() {
    Navigator.pushNamed(context, "/corporateCode");
  }

  void urunEkle() {
    if (_formKey.currentState.validate()) {
      FirebaseFirestore.instance
          .collection('company')
          .doc(_auth.currentUser.email)
          .get()
          .then((value) {
        setState(() {
          FirebaseFirestore.instance
              .collection(value.data()['companyName'])
              .doc(t1.text)
              .set({'urunAdi': t1.text, 'aciklama': t2.text});
        });
      });
      Alert(
          type: AlertType.success,
          context: context,
          title: "ÜRÜN EKLENDİ",
          desc: "Ürününüz Başarıyla Eklendi",
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
}
