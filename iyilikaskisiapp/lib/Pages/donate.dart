import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iyilikaskisiapp/Pages/donateConfirm.dart';
import 'package:iyilikaskisiapp/Pages/maps.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonatePage extends StatefulWidget {
  final String title;
  DonatePage(this.title);

  @override
  donateScreen createState() => donateScreen();
}

// SAYFALARI ÇAĞIRMAK İÇİN KULLANILAN SINIF

class donateScreen extends State<DonatePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Stream collectionStream =
      FirebaseFirestore.instance.collection('products').snapshots();
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  FirebaseAuth _auth = FirebaseAuth.instance;
  String companyName;
  String productName;
  String productPiece;
  String sendCompanyName;
  bool _isLoading = false;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {});
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
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
          primary: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: _userCikis)
            ],
            title: Text("Güncel Bağışlar"),
          ),
          body: Center(
            child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(),
              child: new Column(
                children: [
                  
                  Expanded(
                      flex: 3,
                      child: Container(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: products.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Bir şeyler yanlış gitti!');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text("Yükleniyor...");
                            }

                            return Center(
                              child: Scrollbar(
                                child: ListView(
                                  padding: EdgeInsets.all(7),
                                  children: snapshot.data.docs
                                      .map((DocumentSnapshot document) {
                                    return Card(
                                      elevation: 5,
                                      child: InkWell(
                                          onTap: () {
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 40, vertical: 30),
                                              child: detay(
                                                  document
                                                      .data()['companyName'],
                                                  document.data()[
                                                          ('productPiece')] +
                                                      " Adet  " +
                                                      document.data()[
                                                          'productName'],
                                                  document
                                                      .data()['productName'],
                                                  document.data()['id']),
                                            );
                                          },
                                          splashColor:
                                              Colors.blue.withAlpha(30),
                                          child: ListTile(
                                            title: new Text(
                                              document.data()['companyName'],
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            subtitle: new Text(
                                              document.data()[
                                                      ('productPiece')] +
                                                  " Adet  " +
                                                  document
                                                      .data()['productName'],
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            leading: Icon(Icons.fastfood),
                                            trailing: Icon(
                                                Icons.keyboard_arrow_right),
                                          )),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      )),
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
          )),
    );
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

  bottomBarBagis() {
    Navigator.pushNamed(context, "/makeDonateCorp");
  }

  bottomBarAra() {
    Navigator.pushNamed(context, "/search");
  }

  bottomBarHome() {
    Navigator.pushNamed(context, "/donatePage");
  }

  detay(String dukkan, String urun, String aramaUrun, String idd) {
    String aciklama;
    String adres;

    FirebaseFirestore.instance
        .collection('adresses')
        .doc(dukkan)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> firestoreinfo = documentSnapshot.data();
      setState(() {
        adres = firestoreinfo['adres'];
      });
    });

    FirebaseFirestore.instance
        .collection(dukkan)
        .doc(aramaUrun)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> firestoreinfo = documentSnapshot.data();

      setState(() {
        aciklama = firestoreinfo['aciklama'];
      });

      Alert(
          context: context,
          title: "Bağış Detayları",
          content: Column(
            children: [
              Card(
                elevation: 4,
                child: ListTile(
                  title: Text(dukkan),
                  subtitle: Text(urun),
                  trailing: Image(image: AssetImage('assets/products.png')),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Column(children: [
                Row(
                  children: [
                    Image(image: AssetImage('assets/clipboard.png')),
                    Text(
                      "  Ürün İçeriği",
                      style: TextStyle(fontWeight: FontWeight.normal),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      aciklama,
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    )),
                SizedBox(
                  height: 20,
                ),
                Divider(color: Colors.grey[500]),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Image(image: AssetImage('assets/place-localizer.png')),
                    Text(
                      "  Adres",
                      style: TextStyle(fontWeight: FontWeight.normal),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      adres,
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    )),
              ])
            ],
          ),
          buttons: [
            DialogButton(
                child: Text(
                  "Askıdan Al",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DonateConfirm(
                                id: idd,
                                title: urun,
                                companyName1: dukkan,
                              )));
                }),
                 DialogButton(
                child: Text(
                  "Haritalar",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => GoogleMapPage(adres: adres,)));
                }),
           
          ]).show();
    });
  }

  adres() {}
}
