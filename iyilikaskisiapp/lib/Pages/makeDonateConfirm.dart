import 'package:flutter/src/widgets/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iyilikaskisiapp/Pages/makeDonate.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MakeDonateConfirm extends StatefulWidget {
  String productName1;
  String title;
  String productPiece1;
  String companyName;
  String adress;
  MakeDonateConfirm(
      {this.productName1, this.title, this.productPiece1, this.companyName});

  @override
  makeDonateConfirmScreen createState() => makeDonateConfirmScreen();
}

TextEditingController t1 = TextEditingController();
 var formKey = GlobalKey<FormState>();
class makeDonateConfirmScreen extends State<MakeDonateConfirm> {
  var formKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String aciklama;
  String userCode1;
  String compCode;
  String corporateId;
  String uuid = Uuid().v4();
  final db = FirebaseFirestore.instance;
   int _selectedIndex = 0;
   bool _autovalidate = false;
  bool _isLoading = false;
  void _onItemTapped(int index) {
    setState(() {
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
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: _userCikis)
            ],
            title: Text("Onay Kodu"),
          ),
      resizeToAvoidBottomInset: false,
      body: Container(
        
        constraints: BoxConstraints.expand(),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: Form(
                
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formKey,
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
                                    "Son olarak, bağış yapacağınız iş yerinin İyilik Askısı hesabında beliren onay kodunu giriniz.",
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
                          height: MediaQuery.of(context).size.height * 0.08),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            kodDenetim();
                          },
                          color: Colors.blue[500],
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

  kodDenetim() {
    //id ve kodu değişkene aktarıp kod denetimi yaptım ve yeni koleksiyon oluşturdum

    List<String> list = widget.productName1.split('');

    List<String> indexList = [];

  int dongu = 1;
   
      list.forEach((e) {
     indexList.add(widget.companyName.substring(0, dongu).toLowerCase());
        indexList.add(widget.productName1.substring(0, dongu).toLowerCase());
        dongu++;
        
      });
      
    FirebaseFirestore.instance
        .collection('corpCode')
        .doc(widget.companyName)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> firestoreInfo = documentSnapshot.data();

      setState(() {
        compCode = firestoreInfo['kod'];
      });

      
      //iki kodun eşitliğini kontrol edip eşitse bağışı veri tabanına ekledim ve belgesi id olan bağışlar oluşturdum.
      if (t1.text == compCode) {
        Alert(
            type: AlertType.success,
            context: context,
            title: "Teşekkürler!",
            desc: "Bağışınız başarılı bir şekilde gerçekleşti!",
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

        FirebaseFirestore.instance.collection('corpCode').doc(widget.companyName).update({
          'kod': 0
        });

        srcBol();
        FirebaseFirestore.instance.collection("products").doc(uuid).set({
          'productName': widget.productName1,
          'productPiece': widget.productPiece1,
          'companyName': widget.companyName,
          'searchIndex': indexList,
          
          'id': uuid,
        });
      }
    });

    FirebaseFirestore.instance
        .collection("corpCode")
        .doc(widget.companyName)
        .get()
        .then((value) {
      setState(() {
        corporateId = value.data()['id'];
      });
    });

    //id ve kodu değişkene aktarıp kod denetimi yaptım ve yeni koleksiyon oluşturdum
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
  srcBol() {}

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
