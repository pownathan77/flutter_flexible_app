import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'CheckoutList.dart';
import 'FadeIn.dart';
import 'FadeInOut.dart';
import 'FadeInVert.dart';

Future<List<Address>> getAddress(String aid) async {
  print('getAddress AID: ' + aid.toString());
  final response = await http.post(Uri.https('nmcapstone.rssyn.com', 'Capstone-Backend/getaddress.php'),
    encoding: Encoding.getByName("utf-8"),
    body: <String, String>{
      'aid': aid,
    },
  );

  if (response.statusCode == 200) {
    return compute(parseAddress, response.body);
  }
  else {
    throw Exception('Server error. Try again later.');
  }
}

// A function that converts a response body into a List<Products>.
List<Address> parseAddress(String responseBody) {
  final parsed = jsonDecode(responseBody);
  print(parsed);
  return parsed.map<Address>((json) => Address.fromJson(json)).toList();
}

class Address {
  final String AID;
  final String address_ID;
  final String stateAbbrv;
  final String city;
  final String zipCode;

  Address({this.AID, this.address_ID, this.stateAbbrv, this.city, this.zipCode});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      AID: json['AID'],
      address_ID: json['address_ID'],
      stateAbbrv: json['stateAbbrv'],
      city: json['city'],
      zipCode: json['zipCode'],
    );
  }
}

class CheckoutPage extends StatefulWidget{
  final int aid;

  CheckoutPage({this.aid});
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {

  Future<List<Address>> _getAddress;
  final _registerKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool taxes = false;
  var opened = 0;
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  var isLargeScreen = false;

//  _ProductDescriptionState({Key key, this.productDescription}) : super(key: key);

  @override
  void initState() {
    print('InitState AID: ' + widget.aid.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map checkargs = ModalRoute.of(context).settings.arguments;
    var size = MediaQuery.of(context).size;

    if (MediaQuery.of(context).size.width > 900) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Select an Address'),
      ),
      body: FutureBuilder<List<Address>>(
      future: getAddress(checkargs['aid']),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty == true) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FadeIn(1.0, Center(child: Text('You have no registered addresses! How about we change that.', style: Theme.of(context).textTheme.headline4))),
                  Container(height: 80),
                  FadeIn(2.0, TextButton(onPressed: () {Navigator.pushNamed(context, '/new-address', arguments: {'aid': checkargs['aid']});}, child: Text('REGISTER AN ADDRESS'),),),
                ],
              ),
            );
          }
          print(snapshot.data);
          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 700.0),
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(flex: 2, child: FadeIn(1.0, Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text('Please select an address: ', style: Theme.of(context).textTheme.headline5,),
                        ))),
                        Flexible(flex: 1, child: FadeIn(2.0, Align(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(onPressed: () {Navigator.pushNamed(context, '/new-address', arguments: {'aid': checkargs['aid']});}, child: Text('REGISTER AN ADDRESS'),),
                        )),)),
                      ],
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 700),
                    height: snapshot.data.length * 150.toDouble(),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, position) {
                        return Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(
                            height: 120,
                            child: Card(
                              elevation: 10,
                              child: InkWell(
                                splashColor: Colors.indigoAccent,
                                onTap: () {
                                  print('AID on click: ' + snapshot.data[position].AID);
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return CheckoutList(aid: int.parse(snapshot.data[position].AID), zipCode: snapshot.data[position].zipCode, address_ID: snapshot.data[position].address_ID, stateAbbrv: snapshot.data[position].stateAbbrv, city: snapshot.data[position].city,);
                                    },
                                  ));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(snapshot.data[position].address_ID, style: Theme.of(context).textTheme.headline6,),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(snapshot.data[position].address_ID + " "),
                                          Text(snapshot.data[position].city + ", ", style: Theme.of(context).textTheme.bodyText2,),
                                          Text(snapshot.data[position].stateAbbrv + " ", style: Theme.of(context).textTheme.bodyText2,),
                                          Text(snapshot.data[position].zipCode + " ", style: Theme.of(context).textTheme.bodyText2,),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        else if (snapshot.hasError) {
          print(snapshot.error);
          if (snapshot.error.toString().contains('Unexpected token') != true) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FadeIn(1.0, Text('Only one address crashes and I do not have enough time to fix it, please add another.', style: Theme.of(context).textTheme.headline4)),
                  Container(height: 80),
                  FadeIn(2.0, TextButton(onPressed: () {Navigator.pushNamed(context, '/new-address', arguments: {'aid': checkargs['aid']});}, child: Text('REGISTER AN ADDRESS'),),),
                ],
              ),
            );
          }
          if (snapshot.error.toString().contains('Unexpected token') == true) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FadeIn(1.0, Text('You have no registered addresses! How about we change that.', style: Theme.of(context).textTheme.headline4)),
                  Container(height: 80),
                  FadeIn(2.0, TextButton(onPressed: () {Navigator.pushNamed(context, '/new-address', arguments: {'aid': checkargs['aid']});}, child: Text('REGISTER AN ADDRESS'),),),
                ],
              ),
            );
          }
          return FadeInVert(
            0.2, AlertDialog(
            title: Text('Unable to parse'),
            content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text('Load failed'),
                    Container(
                      height: 8,
                    ),
                    Text(snapshot.error.toString()),
                  ],
                )
            ),
          ),
          );
        }
        return Center(child: Container(height: 10, width: size.width * 0.8, constraints: BoxConstraints(maxWidth: 700), child: LinearProgressIndicator(minHeight: 5.0,)));
      },
    ),
    );
  }
}