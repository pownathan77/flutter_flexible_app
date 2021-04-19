import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'FadeIn.dart';
import 'FadeInOut.dart';
import 'FadeInVert.dart';
import 'MasterDetailPage.dart';

Future<RegisterInfo> RegisterCheck(String email, userPassword, fname, lname, username, phone, taxExempt) async {
  final response = await http.post(Uri.https('nmcapstone.rssyn.com', 'Capstone-Backend/register.php'),
    body: (<String, String>{
      'email' : email,
      'userPassword' : userPassword,
      'fname' : fname,
      'lname' : lname,
      'username': username,
      'phone': phone,
      'taxExempt' : taxExempt,
    }),
  );

  if (response.statusCode == 200) {
    return RegisterInfo.fromJson(jsonDecode(response.body));
  }
  else {
    throw Exception('email and password is incorrect');
  }
}

// TODO: RegisterInfo constructor
class RegisterInfo {
  final String email;
  final String userPassword;
  final String fname;
  final String lname;
  final String username;
  final String phone;
  final String taxExempt;

  RegisterInfo({this.email, this.userPassword, this.fname, this.lname, this.username, this.phone, this.taxExempt});

  factory RegisterInfo.fromJson(Map<String, dynamic> json) {
    return RegisterInfo(
      email: json['email'],
      userPassword: json['userPassword'],
      fname: json['fname'],
      lname: json['lname'],
      username: json['username'],
      phone: json['phone'],
      taxExempt: json['taxExempt'],
    );
  }
}
// TODO: RegisterInfo constructor END

class RegistrationPage extends StatefulWidget {
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // TODO: START STATE FUNCTIONS
  final _registerKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool taxes = false;
  var opened = 0;
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  
  Future<RegisterInfo> _RegisterInfo;

  @override
  Widget build(BuildContext context) {
  var size = MediaQuery.of(context).size;

  
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: Text('Registration', style: TextStyle(color: Colors.indigo[900]),),
        elevation: 0.0,
        backgroundColor: Colors.indigo[50],
        iconTheme: IconThemeData(color: Colors.indigo[900]),
      ),
      body: (_RegisterInfo == null) ? Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _registerKey,
        child: Stack(
          children: [
            (opened == 0) ? FadeInOut(
              0.2, SafeArea(
                child: Center(
                  child: Container(margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20), child: Text("Hello, we're happy you're here!", style: Theme.of(context).textTheme.headline3.copyWith(color: Colors.indigo[900]), textAlign: TextAlign.center,)),
                ),
              ),
            ) : Container(),
            (opened == 0) ? FadeInOut(
              15, SafeArea(
              child: Center(
                child: Container(margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20), child: Text("Let's get you started", style: Theme.of(context).textTheme.headline3.copyWith(color: Colors.indigo[900]), textAlign: TextAlign.center,)),
              ),
            ),
            ) : Container(),
            FadeIn(
              (opened == 0) ? 26 : 0, Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                height: size.height * 0.85,
                child: Stepper(
                  type: stepperType,
                  physics: ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  onStepContinue: continued,
                  onStepCancel: cancel,
                  steps: [
                    Step(
                        title: new Text("Your Name"),
                        subtitle: new Text('If you would please'),
                        content: Container(
                          height: size.height * 0.45,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 3.0),
                                child: FadeIn((opened == 0) ? 27 : 0, Container(
                                  constraints: BoxConstraints(maxWidth: 700),
                                  child: TextFormField(
                                    validator: (_fname) {
                                      if (_fname.length == 0 || _fname.isEmpty) {
                                        return 'First name, no spaces or special characters (Accents and other languages are fine)';
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
                                    ],
                                    controller: _fname,
                                    decoration: InputDecoration(
                                      labelText: 'Enter your first name',
                                      hintText: 'EX: John'
                                    ),
                                  ),
                                ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 15.0),
                                child: FadeIn((opened == 0) ? 28 : 0, Container(
                                  constraints: BoxConstraints(maxWidth: 700),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your last name, no spaces or special characters (Accents and other languages are fine)';
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
                                    ],
                                    controller: _lname,
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      labelText: 'Enter your last name',
                                      hintText: 'EX: Doe',
                                      fillColor: Colors.black,
                                      focusColor: Colors.black,
                                    ),
                                  ),
                                ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep >=0 ?
                        StepState.complete : StepState.disabled
                    ),
                    Step(
                        title: new Text("Your Account"),
                        subtitle: new Text('We have to get you here somehow'),
                        content: Container(
                          height: size.height * 0.45,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 3.0),
                                child: FadeIn((opened == 0) ? 27 : 0, Container(
                                  constraints: BoxConstraints(maxWidth: 700),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.contains('@') == false || value.contains('.') == false || value.isEmpty) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      labelText: 'Enter your email',
                                      hintText: 'example@example.com',
                                    ),
                                  ),
                                ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                                child: FadeIn((opened == 0) ? 28 : 0, Container(
                                  constraints: BoxConstraints(maxWidth: 700),
                                  child: TextFormField(
                                    validator: validatePassword,
                                    controller: _password,
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Enter your password',
                                      fillColor: Colors.black,
                                      focusColor: Colors.black,
                                    ),
                                  ),
                                ),
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(maxWidth: 700),
                                height: 27,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                                child: FadeIn((opened == 0) ? 28 : 0, Container(
                                  constraints: BoxConstraints(maxWidth: 700),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    validator: (_username) {
                                      if (_username == null || _username.isEmpty) {
                                        return 'Username cannot contain spaces or special characters';
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                                    ],
                                    controller: _username,
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      labelText: 'Enter your username',
                                      fillColor: Colors.black,
                                      focusColor: Colors.black,
                                    ),
                                  ),
                                ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                                child: FadeIn((opened == 0) ? 28 : 0, Container(
                                  constraints: BoxConstraints(maxWidth: 700),
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    validator: (_phone) {
                                      if (_phone.length < 10 || _phone.length > 10 || _phone.isEmpty) {
                                        return 'Can only contain digits, US numbers only';
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                    ],
                                    controller: _phone,
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      labelText: 'Enter a phone number',
                                      hintText: '1112223333',
                                      fillColor: Colors.black,
                                      focusColor: Colors.black,
                                    ),
                                  ),
                                ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep >=0 ?
                        StepState.complete : StepState.disabled
                    ),
                    Step(
                      title: new Text("Extras"),
                      subtitle: new Text('Personalized just for you'),
                      content: Container(
                        alignment: Alignment.centerLeft,
                        height: size.height * 0.45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 3.0),
                                child: FadeIn((opened == 0) ? 28 : 0, Container(
                                  constraints: BoxConstraints(maxWidth: 700),
                                  child: SwitchListTile(
                                    title: Text('Tax Exemption Status', style: TextStyle(color: Colors.indigo)),
                                    subtitle: Text('Are you a registered 503C Nonprofit or NGO?'),
                                    value: taxes, onChanged: (bool value) {
                                      setState(() {
                                        taxes = value;
                                      });
                                    }
                                ),
                                ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      isActive:_currentStep >= 0,
                      state: _currentStep >= 2 ?
                      StepState.complete : StepState.disabled,
                    ),
                  ],


                ),
              ),
            ),
          ],
        ),
      ) : FutureBuilder<RegisterInfo>(
          future: _RegisterInfo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.email == _controller.text && snapshot.data.userPassword == _password.text && snapshot.data.fname == _fname.text && snapshot.data.lname == _lname.text && snapshot.data.phone == _phone.text && snapshot.data.username == _username.text) {
                return FadeInVert(
                  0.2, AlertDialog(
                  title: Text('Our newest member!'),
                  content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Text(snapshot.data.username + ", welcome!"),
                        ],
                      )
                  ),
                  actions: [
                    TextButton(
                      child: Text('Continue'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                );
              }
              else if (snapshot.data.email != _controller.text || snapshot.data.userPassword != _password.text || snapshot.data.username != _username.text || snapshot.data.fname != _fname.text || snapshot.data.lname != _lname.text || snapshot.data.phone != _phone.text) {
                return FadeInVert(
                  0.2, AlertDialog(
                  title: Text('Unable to log in'),
                  content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Text('The email, username, or phone number is already taken.'),
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
                          _RegisterInfo = null;
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
                        Text('Unable to process', style: Theme.of(context).textTheme.bodyText1,),
                        Container(
                          height: 10,
                        ),
                        Text("The email, username, or phone number is already taken. Please try again.", style: Theme.of(context).textTheme.bodyText1,),
                      ],
                    )
                ),
                actions: [
                  TextButton(
                    child: Text('Close',),
                    onPressed: () {
                      setState(() {
                        _RegisterInfo = null;
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
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step){
    setState(() => _currentStep = step);
  }

  continued(){
    _currentStep < 2 ?
    setState(() => _currentStep += 1) : _registerKey.currentState.validate() ? setState(() {opened = 1; _RegisterInfo = RegisterCheck(_controller.text, _password.text, _fname.text, _lname.text, _username.text, _phone.text, (taxes ? "Y" : "N"));}) : setState(() {opened = 1;});
  }
  cancel(){
    _currentStep > 0 ?
    setState(() => _currentStep -= 1) : Navigator.pop(context);
  }

  String validatePassword (String _password) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (_password.length < 5 || !regex.hasMatch(_password) == false) {
      return 'A password must be more than 5 characters and contain a special character';
    }
    else {
      return null;
    }
  }
}