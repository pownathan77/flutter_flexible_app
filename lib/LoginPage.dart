import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:http/http.dart' as http;

import 'FadeIn.dart';
import 'FadeInVert.dart';
import 'MasterDetailPage.dart';

Future<LoginInfo> loginCheck(String email, userPassword) async {
  final response = await http.post(Uri.https('nmcapstone.rssyn.com', 'Capstone-Backend/login.php'),
    encoding: Encoding.getByName("utf-8"),
  body: <String, String>{
    'email' : email,
    'userPassword' : userPassword,
      },
  );

  if (response.statusCode == 200) {
    return LoginInfo.fromJson(jsonDecode(response.body));
  }
  else {
    throw Exception('Server error. Try again later.');
  }
}

// TODO: LoginInfo constructor
class LoginInfo {
  final String AID;
  final String email;
  final String userPassword;
  final String username;
  final String fname;
  final String lname;
  final String phone;
  final String taxable;

  LoginInfo({this.email, this.userPassword, this.phone, this.fname, this.lname, this.username, this.AID, this.taxable});

  factory LoginInfo.fromJson(Map<String, dynamic> json) {
    return LoginInfo(
      AID: json['AID'],
      email: json['email'],
      userPassword: json['userPassword'],
      username: json['username'],
      fname: json['fname'],
      lname: json['lname'],
      phone: json['phone'],
      taxable: json['taxExempt'],
    );
  }
}
// TODO: LoginInfo constructor END

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  // TODO: TWO CONTROLLERS, ONE email ONE PASSWORD
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _password = TextEditingController();
  Future<LoginInfo> _LoginInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            tileMode: TileMode.mirror,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff360033),
              Color(0xff0b8793),
            ],
            stops: [
              0.2,
              1.0,
            ],
          ),
          backgroundBlendMode: BlendMode.srcOver,
        ),
        child: PlasmaRenderer(
          child: (_LoginInfo == null) ? Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: 'assets/loading_material.gif',
                   placeholderScale: 3.0,
                    image: 'https://nmcapstone.rssyn.com/wordpress/wp-content/uploads/2021/03/mobilecom_app_logo.png',
                    imageScale: 2.5
                  ),
                  Divider(color: Colors.transparent, height: 15),
                  FadeInVert(1, Text('Mobilecom', style: TextStyle(fontSize: 50, color: Colors.white, shadows: [Shadow(blurRadius: 10.0, color: Color(0xFF202020), offset: Offset(5.0, 5.0)),],))),
                  Divider(color: Colors.transparent, height: 80,),
                  Padding(
                    padding: EdgeInsets.fromLTRB(80.0, 15.0, 80.0, 3.0),
                    child: FadeIn(2, Container(
                      constraints: BoxConstraints(maxWidth: 700),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.contains('@') == false || value.contains('.') == false || value.isEmpty) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                          controller: _controller,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Enter your email',
                            labelStyle: TextStyle(color: Color(0xffefefef)),
                            fillColor: Colors.white,
                            focusColor: Colors.white,
                          ),
                        ),
                    ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(80.0, 5.0, 80.0, 15.0),
                    child: FadeIn(3, Container(
                      constraints: BoxConstraints(maxWidth: 700),
                      child: TextFormField(
                          controller: _password,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Enter your password',
                            labelStyle: TextStyle(color: Color(0xffefefef)),
                            fillColor: Colors.white,
                            focusColor: Colors.white,
                          ),
                        ),
                    ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(60.0, 55.0, 60.0, 15.0),
                    child: FadeInVert(4, ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _LoginInfo =
                                  loginCheck(_controller.text, _password.text);
//                        Navigator.pushNamed(context, '/main');
                            });
                          }
                        },
                        child: Text('Log in'),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                            textStyle: TextStyle(color: Colors.white),
                            minimumSize: Size(100.0, 45.0),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        ),
                      ),
                    ),
                  ),
                  Divider(color: Colors.transparent, height: MediaQuery.of(context).size.height * 0.15,),
                  FadeInVert(
                    10, ElevatedButton(
                      child: Text('New? Register Here'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.indigoAccent,
                          textStyle: TextStyle(color: Colors.white),
                          minimumSize: Size(100.0, 45.0),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                      onPressed: () {
                          setState(() {
                            Navigator.pushNamed(context, '/register');
                          });
                      }
                    ),
                  ),
                ],
            ),
          ) : FutureBuilder<LoginInfo>(
              future: _LoginInfo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.email == _controller.text && snapshot.data.userPassword == _password.text) {
                    print('AID: ' + snapshot.data.AID.toString());
                    return FadeInVert(
                      0.2, AlertDialog(
                        title: Text('Welcome!'),
                        content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Text('We hope you enjoy'),
                              ],
                            )
                        ),
                        actions: [
                          TextButton(
                            child: Text('Continue'),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => MasterDetailPage(email: _controller.text.toString(), username: snapshot.data.username, phone: snapshot.data.phone, lname: snapshot.data.lname, fname: snapshot.data.fname, aid: int.parse(snapshot.data.AID), tax: snapshot.data.taxable)));
                            },
                          )
                        ],
                      ),
                    );
                  }
                  else if (snapshot.data.email != _controller.text || snapshot.data.userPassword != _password.text) {
                    return FadeInVert(
                      0.2, AlertDialog(
                        title: Text('Unable to log in'),
                        content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Text('email or password is incorrect.'),
                                Container(
                                  height: 5,
                                ),
                                Text("Please try again."),
                              ],
                            )
                        ),
                        actions: [
                          TextButton(
                            child: Text('Close'),
                            onPressed: () {
                              setState(() {
                                _LoginInfo = null;
                              });
                            },
                          )
                        ],
                      ),
                    );
                  }
                }
                else if (snapshot.hasError) {
                  return FadeInVert(
                    0.2, AlertDialog(
                      title: Text('Unable to log in'),
                      content: SingleChildScrollView(
                          child: ListBody(
                            children: [
                              Text('Incorrect Data'),
                              Container(
                                height: 5,
                              ),
                              Text("Username or password is invalid."),
                            ],
                          )
                      ),
                      actions: [
                        TextButton(
                          child: Text('Close'),
                          onPressed: () {
                            setState(() {
                              _LoginInfo = null;
                            });
                          },
                        )
                      ],
                    ),
                  );
                }

                return Center(
                    child: Container(
                      height: 50,
                        width: 50,
                        child: CircularProgressIndicator()));
              }),
          type: PlasmaType.bubbles,
          particles: 10,
          color: Color(0x44203a43),
          blur: 0.4,
          size: 1,
          speed: 1,
          offset: 0,
          blendMode: BlendMode.plus,
          variation1: 0,
          variation2: 0,
          variation3: 0,
          rotation: 0,
        ),
      ),
    );
  }
}