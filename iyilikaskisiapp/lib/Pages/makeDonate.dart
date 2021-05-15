import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iyilikaskisiapp/Pages/makeDonateConfirm.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:iyilikaskisiapp/Pages/makeDonateCorp.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MakeDonate extends StatefulWidget {
  final String title, companyName1;

  MakeDonate(this.title, {this.companyName1});

  @override
  makeDonateScreen createState() => makeDonateScreen();
}

// SAYFALARI ÇAĞIRMAK İÇİN KULLANILAN SINIF

class makeDonateScreen extends State<MakeDonate> {
  String _urunAdiVal;
  var formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  TextEditingController t2 = TextEditingController();

  String productName;
  String productPiece;

  String userCode;
  int _selectedIndex = 0;
  bool _isLoading = false;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    
    });
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
      appBar: AppBar(
        title: Text("Bağış Yap"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              iconSize: 40,
              color: Colors.white,
              onPressed: _userCikis)
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        constraints: BoxConstraints.expand(),
      

                  child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Form(
                key: formKey,
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                       Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                    Image(image: AssetImage('assets/products.png')),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.07,),
                                  Expanded(
                                    child: Text(
                                      "Daha sonra, askıya asmak istediğiniz ürünün adını ve adetini seçiniz.",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.09),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection(widget.companyName1)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return new Text("Lütfen Bekleyiniz...");
                            
                            var length = snapshot.data.docs.length;
                            DocumentSnapshot ds = snapshot.data.docs[length - 1];

                            return Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 0.0, right: 0.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1.0),
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                  child: new DropdownButton(
                                     underline: SizedBox(),
                                    hint: new Text("Lütfen Ürün Seçiniz"),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                    elevation: 0,
                                    iconSize: 36.0,
                                    isExpanded: true,
                                    items: snapshot.data.docs
                                    
                                        .map((DocumentSnapshot document) {
                                          
                                      return DropdownMenuItem(
                                          value: document.data()['urunAdi'],
                                          child: new Text(
                                              document.data()["urunAdi"]));
                                    }).toList(),
                                    value: _urunAdiVal,
                                    onChanged: (value) {
                                      setState(() {
                                        _urunAdiVal = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            );
                          }),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: t2,
                        onSaved: (x) {
                          setState(() {
                            productPiece = x;
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
                          
                          errorStyle: TextStyle(fontSize: 18),
                          labelText: "Ürün Adeti",
                          labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
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
              
                      Container(
                        
                        child: RaisedButton(
                          onPressed: urunAs,
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          hoverColor: Colors.black,
                          child: Text(
                            "Onayla",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.20,
              ),
              new Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                 
                    child: BottomNavigationBar(
                      selectedItemColor: Colors.blueGrey,
                      unselectedItemColor: Colors.grey,
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.search,
                            size: 40,
                          ),
                          label: 'Ara',
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
                      onTap: _onItemTapped,
                    ),
                  ),
            ],
          ),

      ),
    );
  }

  urunAs() {
    if (_urunAdiVal == null) {
      Alert(
          type: AlertType.warning,
          context: context,
          title: "HATA!",
          desc: "Lütfen İşletme Seçimi Yapınız",
          buttons: [
            DialogButton(
                child: Text(
                  "Kapat",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ]).show();
    } else {
      if (formKey.currentState.validate()) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MakeDonateConfirm(
                      companyName: widget.companyName1,
                      productPiece1: t2.text,
                      productName1: _urunAdiVal,
                    )));
      } else {}
    }
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

  void _userCikis() async {
    setState(() {
      _isLoading = true;
    });
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
      setState(() {
        _isLoading = false;
      });
    });
  }
}
