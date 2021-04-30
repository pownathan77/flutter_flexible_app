import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'DetailWidget.dart';
import 'OrdersPage.dart';
import 'package:http/http.dart' as http;

import 'ProductDescriptionPage.dart';

typedef Null ItemSelectedCallback(int value);

Future<List<OrdersInventory>> GetOrders(int aid) async {
  print('getOrders: ' + aid.toString());
  final response = await http.post(Uri.https('nmcapstone.rssyn.com', 'Capstone-Backend/orderlist.php'),
    encoding: Encoding.getByName("utf-8"),
    body: <String, String>{
      'aid': aid.toString(),
    },
  );

  if (response.statusCode == 200) {
    return compute(parseOrders, response.body);
  }
  else {
    throw Exception('Server error. Try again later.');
  }
}

// A function that converts a response body into a List<Products>.
List<OrdersInventory> parseOrders(String responseBody) {
  final parsed = jsonDecode(responseBody);
  print(parsed);
  return parsed.map<OrdersInventory>((json) => OrdersInventory.fromJson(json)).toList();
}

class OrdersInventory {
  final String SID;
  final String CID;
  final String AID;
  final String purchaseDateTime;
  final String subtotal;
  final String tax;
  final String total;
  final String address;

  OrdersInventory({this.SID, this.CID, this.AID, this.purchaseDateTime, this.subtotal, this.tax, this.total, this.address});

  factory OrdersInventory.fromJson(Map<String, dynamic> json) {
    return OrdersInventory(
      CID: json['CID'],
      AID: json['AID'],
      SID: json['SID'],
      address: json['address'],
      purchaseDateTime: json['purchaseDateTime'],
      subtotal: json['subtotal'],
      total: json['total'],
      tax: json['tax'],
    );
  }
}

class OrdersInventoryList extends StatefulWidget {
  final List<OrdersInventory> orders;

  OrdersInventoryList({Key key, this.orders,}) : super(key: key);

  OrdersInventoryState createState() => OrdersInventoryState();
}

class OrdersInventoryState extends State<OrdersInventoryList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    var isLargeScreen = false;

    if (MediaQuery.of(context).size.width > 900) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }

    return Container(
      constraints: BoxConstraints(maxWidth: 700),
      height: widget.orders.length * 230.toDouble(),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: (widget.orders.length == 1) ? 1 : widget.orders.length,
        itemBuilder: (context, position) {
          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: Container(
              height: 200,
              child: Card(
                elevation: 10,
                child: InkWell(
                  splashColor: Colors.indigoAccent,
                  onTap: () {
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
                                  image: NetworkImage('https://nmcapstone.rssyn.com/wordpress/wp-content/uploads/2021/03/mobilecom_app_logo.png'),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10), height: 50, width: (isLargeScreen ? 540 : size.width * 0.56), child: Text('Order ' + widget.orders[position].SID + ' - ' + widget.orders[position].total, style: TextStyle(fontSize: isLargeScreen ? 22.0 : 20.0, fontFamily: 'Montserrat Medium'), textAlign: TextAlign.start,)),
                              Container(margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10), height: 50, width: (isLargeScreen ? 540 : size.width * 0.56), child: Text('Delivered to: ' + widget.orders[position].address, style: TextStyle(fontSize: isLargeScreen ? 20.0 : 18.0, fontFamily: 'Montserrat Medium', color: Colors.black.withOpacity(0.8)), textAlign: TextAlign.start,)),
                              Container(
                                width: (isLargeScreen ? 540 : size.width * 0.64),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(alignment: Alignment.bottomLeft, child: Text(("Total: " + widget.orders[position].total == '0.00' ? 'FREE' :   '\$' + widget.orders[position].total), style: TextStyle(fontSize: isLargeScreen ? 18.0 : 17.0, fontFamily: 'Montserrat Medium', color: Colors.black.withOpacity(0.6)),)),
                                    Align(alignment: Alignment.bottomRight, child: Row(children: [                                    Text("Time:  ", style: TextStyle(fontFamily: 'Montserrat Medium', fontSize: isLargeScreen ? 18 : 15)),
                                      Container(
                                        height: 40,
                                        width: 180,
                                        child: Center(
                                          child: Text(widget.orders[position].purchaseDateTime),
                                        ),
                                      ),],))
                                  ],
                                ),
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
      ),
    );
  }
}