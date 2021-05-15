import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:iyilikaskisiapp/Pages/corporateCode.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';


class CorporateLoginUser extends StatefulWidget {
  final String title;

  CorporateLoginUser({this.title});

  @override
  corporateLoginScreen createState() => corporateLoginScreen();
}
//sevde
class corporateLoginScreen extends State<CorporateLoginUser> {
  var formKey = GlobalKey<FormState>();
  TextEditingController t1 = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  String email;
  String password;
  bool _isLoading = false;
  bool _isHidden = false;
  String idGonder;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.all( MediaQuery.of(context).size.height*0.03,),
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/backGroundIcon.png"),
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.2,
                      ),
                      Text(
                        "Giriş Yap",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.05,
                      ),
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
                      SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                      TextFormField(
                        onSaved: (x) {
                          setState(() {
                            password = x;
                          });
                        },
                         obscureText: _isHidden ? false : true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                           suffixIcon: IconButton(
                            icon:
                                Icon(_isHidden ? Icons.remove_red_eye : Icons.remove_red_eye_outlined),
                            onPressed: sifreGoster,
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue,
                          ),
                          labelText: "Şifre",
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.grey),
                          errorStyle: TextStyle(
                            fontSize: 18,
                          ),
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
                        height: 10
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: RichText(
                          text: TextSpan(
                              text: 'Şifremi unuttum',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 15),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _sifreGonder();
                                }),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: _emailSifreGiris,
                            color: Colors.blue[500],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            hoverColor: Colors.black,
                            child: Text(
                              "Giriş Yap",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.06,),
               
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                              child: RichText(
                                  text: TextSpan(
                                      text: 'Hesabın yok mu?',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                      children: <TextSpan>[
                                TextSpan(
                                    text: ' Kaydol',
                                    style: TextStyle(
                                        color: Colors.blue[500]),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                            context, "/createCorporateUser");
                                      }),
                              ])))
                        ],
                      ),

                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _emailSifreGiris() async {
    setState(() {
      _isLoading = true;
    });
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) {
        if (user.user.emailVerified == false) {
          Alert(
              type: AlertType.warning,
              context: context,
              title: "HATA!",
              desc:
                  "Lütfen Email Adresinizi Emailinize Gelen Mesajla Onaylayın. \n Email Ulaşmadıysa Aşağıdaki Butonu Tıklayınız!",
              buttons: [
                DialogButton(
                    child: Text(
                      "AKTİVASYON MAİLİ GÖNDER",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      user.user.sendEmailVerification();
                      Navigator.pop(context);
                    }),
              ]).show();
          setState(() {
            _isLoading = false;
          });
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CorporateCode(email: t1.text)));
          formKey.currentState.reset();
        }
      }).catchError((onError) {
        Alert(
            type: AlertType.warning,
            context: context,
            title: "GİRİŞ YAPILAMADI!",
            desc: "Hatalı Email Adresi / Şifre",
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
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }



  _sifreGonder() async {

    if (formKey.currentState.validate()) {
      formKey.currentState.save();
    }
    await _auth.sendPasswordResetEmail(email: email).then((value) {

      Alert(
          type: AlertType.success,
          context: context,
          title: "ŞİFRE GÖNDERİLDİ!",
          desc: "Lütfen Email Adresinizi Kontrol Ediniz!!",
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

   sifreGoster() {
     
     FocusScope.of(context).unfocus();
    setState(() {
      if (!_isHidden) {
        this._isHidden = !this._isHidden;
      } else if (_isHidden) {
        this._isHidden = !this._isHidden;
      }
    });
  }
}
