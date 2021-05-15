import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iyilikaskisiapp/Pages/donateConfirm.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isSearching = false;
  int _selectedIndex = 0;

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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController t1 = TextEditingController();
  String searchString;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: !isSearching
              ? Text("Detaylı Arama")
              : TextField(
                  style: TextStyle(color: Colors.white, fontSize: 19),
                  controller: t1,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      hintText: "Ürün ya da İş Yeri Giriniz",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 19)),
                ),
          actions: <Widget>[
            isSearching
                ? IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        this.isSearching = !this.isSearching;
                      });
                    })
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        this.isSearching = !this.isSearching;
                      });
                    })
          ],
        ),
        body: Container(
          child: Form(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: (t1.text == null || t1.text.trim() == '')
                          ? FirebaseFirestore.instance
                              .collection('products')
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection('products')
                              .where('searchIndex', arrayContains: t1.text)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Bir şeyler yanlış gitti!');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Yükleniyor...");
                        }
                        if (snapshot.connectionState == null) {
                          return Text("Hiç Bağış Yok...");
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
                                              document.data()['companyName'],
                                              document.data()[
                                                      ('productPiece')] +
                                                  " Adet  " +
                                                  document
                                                      .data()['productName'],
                                              document.data()['productName'],
                                              document.data()['id']),
                                        );
                                      },
                                      splashColor: Colors.blue.withAlpha(30),
                                      child: ListTile(
                                        title: new Text(
                                          document.data()['companyName'],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        subtitle: new Text(
                                          document.data()[('productPiece')] +
                                              " Adet  " +
                                              document.data()['productName'],
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        trailing:
                                            Icon(Icons.keyboard_arrow_right),
                                      )),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                new Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: BottomNavigationBar(
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
                        label: "Bağış Yap",
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
        ),
      ),
    );
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
          ]).show();
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
}

class Data {}
