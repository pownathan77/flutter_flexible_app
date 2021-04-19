import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'FadeIn.dart';
import 'FadeInOut.dart';
import 'FadeInVert.dart';

Future<AddressInfo> AddressCheck(String AID, String state, String address, String city, String zip) async {
  final response = await http.post(Uri.https('nmcapstone.rssyn.com', 'Capstone-Backend/newaddress.php'),
    body: (<String, String>{
      'AID': AID,
      'state': state,
      'address': address,
      'city': city,
      'zip': zip,
    }),
  );

  if (response.statusCode == 200) {
    return AddressInfo.fromJson(jsonDecode(response.body));
  }
  else {
    throw Exception('Server error, please try again later');
  }
}

// TODO: AddressInfo constructor
class AddressInfo {
  final String AID;
  final String state;
  final String address;
  final String city;
  final String zip;

  AddressInfo({this.AID, this.state, this.address, this.city, this.zip});

  factory AddressInfo.fromJson(Map<String, dynamic> json) {
    return AddressInfo(
      AID: json['AID'],
      state: json['state'],
      address: json['address'],
      city: json['city'],
      zip: json['zip'],
    );
  }
}
// TODO: AddressInfo constructor END

class AddressPage extends StatefulWidget {
  String aid;

  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  // TODO: START STATE FUNCTIONS
  String dropdownValue = 'AK';
  final _registerKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool taxes = false;
  var opened = 1;
  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;
  final TextEditingController _city = TextEditingController();
  final TextEditingController _zip = TextEditingController();
  final TextEditingController _address1 = TextEditingController();

  Future<AddressInfo> _AddressInfo;

  @override
  Widget build(BuildContext context) {
    final Map addressargs = ModalRoute.of(context).settings.arguments;
    var size = MediaQuery.of(context).size;
    var isLargeScreen = false;

    if (MediaQuery.of(context).size.width > 900) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }

    print("addressargs: " + addressargs['aid']);

    widget.aid = addressargs['aid'];

    print("widget.aid: " + widget.aid);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: Text('Create an Address', style: TextStyle(color: Colors.indigo[900]),),
        elevation: 0.0,
        backgroundColor: Colors.indigo[50],
        iconTheme: IconThemeData(color: Colors.indigo[900]),
      ),
      body: (_AddressInfo == null) ? Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _registerKey,
        child: Stack(
          children: [
            Positioned(
              left: isLargeScreen ? size.width * 0.50 + 50 : 0,
              top: isLargeScreen ? 150 : size.height * 0.5874,
              child: Icon(Icons.apartment, color: isLargeScreen ? Colors.teal[100] : Colors.indigo[50], size: isLargeScreen ? 800.0 : 500.0),
            ),
            Positioned(
              left: isLargeScreen ? size.width * 0.50 + 140 : 0,
              top: isLargeScreen ? 250 : 0,
              child: Icon(Icons.mail_outline, color: isLargeScreen ? Colors.amber[200] : Colors.indigo[50], size: isLargeScreen ? 200.0 : 0.0),
            ),
            Positioned(
              left: isLargeScreen ? size.width * 0.50 + 700 : 0,
              top: isLargeScreen ? 515 : 0,
              child: Icon(Icons.mail_outline, color: isLargeScreen ? Colors.red[200] : Colors.indigo[50], size: isLargeScreen ? 200.0 : 0.0),
            ),
            Positioned(
              left: isLargeScreen ? size.width * 0.50 : -50,
              top: isLargeScreen ? 650 : size.height * 0.5874,
              child: Icon(Icons.mail_outline, color: isLargeScreen ? Colors.indigo[200] : Colors.indigo[100], size: isLargeScreen ? 200.0 : 500.0),
            ),
            FadeIn(
              (opened == 0) ? 26 : 0, Column(
                children: [
                  Container(
                  height: size.height * 0.75,
                  child: Stepper(
                    type: stepperType,
                    physics: ScrollPhysics(),
                    currentStep: _currentStep,
                    onStepTapped: (step) => tapped(step),
                    onStepContinue: continued,
                    onStepCancel: cancel,
                    steps: [
                      Step(
                          title: new Text("New Address"),
                          subtitle: new Text("Where can we send it?"),
                          content: Container(
                            height: size.height * 0.55,
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 8.0),
                                    child: FadeIn((opened == 0) ? 27 : 0, Container(
                                      constraints: BoxConstraints(maxWidth: 700),
                                      child: TextFormField(
                                        validator: (_fname) {
                                          if (_fname.length == 0 || _fname.isEmpty) {
                                            return 'Enter your street address';
                                          }
                                          return null;
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\s]')),
                                        ],
                                        controller: _address1,
                                        decoration: InputDecoration(
                                            labelText: 'Address',
                                            hintText: 'EX: 111 Example Avenue'
                                        ),
                                      ),
                                    ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 15.0),
                                  child: FadeIn((opened == 0) ? 28 : 1.0,
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 700),
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter your city';
                                            }
                                            return null;
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z\s]')),
                                          ],
                                          controller: _city,
                                          cursorColor: Colors.black,
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                            labelText: 'Enter your city',
                                            hintText: 'EX: Pittsburgh',
                                            fillColor: Colors.black,
                                            focusColor: Colors.black,
                                          ),
                                        ),
                                      ),
                                  ),
                                ),
                                      FadeIn(
                                        2.0, Padding(
                                          padding: EdgeInsets.fromLTRB(0.0, .0, 0.0, 15.0),
                                          child: Container(
                                            constraints: BoxConstraints(maxWidth: 700),
                                            child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter your ZIP Code';
                                                }
                                                return null;
                                              },
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                                              ],
                                              controller: _zip,
                                              cursorColor: Colors.black,
                                              style: TextStyle(color: Colors.black),
                                              decoration: InputDecoration(
                                                labelText: 'Enter your ZIP Code',
                                                hintText: 'EX: 22000',
                                                fillColor: Colors.black,
                                                focusColor: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                FadeIn(
                                  3, Container(
                                    constraints: BoxConstraints(maxWidth: 700),
                                    child: Column(
                                      children: [
                                        Center(child: Text('State', style: Theme.of(context).textTheme.button,),),
                                        DropdownButton<String>(
                                          value: dropdownValue,
                                          icon: const Icon(Icons.arrow_downward),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: const TextStyle(color: Colors.indigo),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.indigoAccent,
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              dropdownValue = newValue;
                                            });
                                          },
                                          items: <String>['AK', 'AL', 'AR', 'AS', 'AZ', 'CA', 'CO', 'CT', 'DC', 'DE', 'FL', 'GA', 'GU', 'HI', 'IA', 'ID', 'IL', 'IN', 'KS', 'KY', 'LA', 'MA', 'MD', 'ME', 'MI', 'MN', 'MO', 'MP', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ', 'NM', 'NV', 'NY', 'OH', 'OK', 'OR', 'PA', 'PR', 'RI', 'SC', 'SD', 'TN', 'TX', 'UM', 'UT', 'VA', 'VI', 'VT', 'WA', 'WI', 'WV', 'WY']
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isActive: _currentStep >= 0,
                          state: _currentStep >=0 ?
                          StepState.editing : StepState.disabled
                      ),
                    ],
                  ),
            ),
                ],
              ),
            ),
          ],
        ),
      ) : FutureBuilder<AddressInfo>(
          future: _AddressInfo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.state == dropdownValue && snapshot.data.address == _address1.text && snapshot.data.zip == _zip.text && snapshot.data.city == _city.text && snapshot.data.AID == addressargs['aid'].toString()) {
                return FadeInVert(
                  0.2, AlertDialog(
                  title: Text('Thank you!'),
                  content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Text(snapshot.data.address + " saved"),
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
              else if (snapshot.data.state != dropdownValue || snapshot.data.address != _address1.text || snapshot.data.zip != _zip.text || snapshot.data.city != _city.text || snapshot.data.AID != addressargs['aid'].toString()) {
                return FadeInVert(
                  0.2, AlertDialog(
                  title: Text('Unable to log in'),
                  content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Text(snapshot.error),
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
                          _AddressInfo = null;
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
                title: Text('Unable to submit'),
                content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Text('Snapshot error', style: Theme.of(context).textTheme.bodyText1,),
                        Container(
                          height: 10,
                        ),
                        Text(snapshot.error, style: Theme.of(context).textTheme.bodyText1,),
                      ],
                    )
                ),
                actions: [
                  TextButton(
                    child: Text('Close',),
                    onPressed: () {
                      setState(() {
                        _AddressInfo = null;
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
    _currentStep > 1 ?
    setState(() => _currentStep += 1) : _registerKey.currentState.validate() ? setState(() {opened = 1; print("Sent: " + widget.aid + ", " + dropdownValue + ", " + _address1.text + ", " + _city.text + ", " + _zip.text); _AddressInfo = AddressCheck(widget.aid, dropdownValue, _address1.text, _city.text, _zip.text);}) : setState(() {opened = 1;});
  }
  cancel(){
    _currentStep > 0 ?
    setState(() => _currentStep -= 1) : Navigator.pop(context);
  }
}