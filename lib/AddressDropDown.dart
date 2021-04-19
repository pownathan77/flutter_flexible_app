import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'FadeInVert.dart';

Future<List<Address>> getAddress(int aid) async {
  print('getAddress AID: ' + aid.toString());
  final response = await http.post(Uri.https('nmcapstone.rssyn.com', 'Capstone-Backend/getaddress.php'),
    encoding: Encoding.getByName("utf-8"),
    body: <String, String>{
      'aid': aid.toString(),
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
  final String address;

  Address({this.address});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
    );
  }
}

class AddressDropDown extends StatefulWidget {
  final int aid;

  AddressDropDown({this.aid});

  _AddressDropDownState createState() => _AddressDropDownState();
}

class _AddressDropDownState extends State<AddressDropDown> {
  Future<List<Address>> _address;
  String _chosenValue;

  @override
  void initState() {
    _address = getAddress(widget.aid);
    print('InitState AID: ' + widget.aid.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Map below: ');
    print(<String>[_address.toString()].map);
    return FutureBuilder(
      future: getAddress(widget.aid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _chosenValue = snapshot.data[0].address;
          return ListView.builder(
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
                        print('PID on click: ' + snapshot.data[position].PID.toString());
                        print('AID on click: ' + AID.toString());
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ProductDescriptionPage(pid: int.parse(snapshot.data[position].PID), aid: AID,);
                          },
                        ));
                      },
                      child: Wrap(
                        children: <Widget>[
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16.0, 8, 8, 8),
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: 80, maxHeight: 80),
                                  height: isLargeScreen ? 80 : size.height * 0.1,
                                  width: isLargeScreen ? 80 : size.width * 0.2,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage((snapshot.data[position].image == null) ? 'https://nmcapstone.rssyn.com/wordpress/wp-content/uploads/2021/03/mobilecom_app_logo.png' : snapshot.data[position].image),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10), height: 50, width: (isLargeScreen ? null: size.width * 0.56), child: Text(snapshot.data[position].title, style: TextStyle(fontSize: 22.0, fontFamily: 'Montserrat Medium'), textAlign: TextAlign.start,)),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10.0, 10, 16, 10),
                                    child: Align(alignment: Alignment.bottomLeft, child: Text((snapshot.data[position].price == '0.00' ? 'FREE' :   '\$' + snapshot.data[position].price), style: TextStyle(fontSize: 18.0, fontFamily: 'Montserrat Medium', color: Colors.black.withOpacity(0.6)),)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
        else if (snapshot.hasError) {
          print(snapshot.error);
          return DropdownButton(
              focusColor:Colors.white,
              value: _chosenValue,
              //elevation: 5,
              style: TextStyle(color: Colors.white),
              iconEnabledColor:Colors.black,
              items: [snapshot.error.toString()].map((String value) => new DropdownMenuItem<String>(
                  value: value,
                child: new Text(value),
              )).toList()
          );
        }
        else return DropdownButton(
            focusColor:Colors.white,
            value: _chosenValue,
            //elevation: 5,
            style: TextStyle(color: Colors.white),
            iconEnabledColor:Colors.black,
            items: []);
      },
    );
  }
}