import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'DetailWidget.dart';
import 'CartPage.dart';
import 'package:http/http.dart' as http;

import 'ProductDescriptionPage.dart';

typedef Null ItemSelectedCallback(int value);

Future<List<CheckoutProduct>> GetList(int aid) async {
  print('getCart: ' + aid.toString());
  final response = await http.post(Uri.https('nmcapstone.rssyn.com', 'Capstone-Backend/showcart.php'),
    encoding: Encoding.getByName("utf-8"),
    body: <String, String>{
      'aid': aid.toString(),
    },
  );

  if (response.statusCode == 200) {
    return compute(parseCart, response.body);
  }
  else {
    throw Exception('Server error. Try again later.');
  }
}

// A function that converts a response body into a List<Products>.
List<CheckoutProduct> parseCart(String responseBody) {
  final parsed = jsonDecode(responseBody);
  print(parsed);
  return parsed.map<CheckoutProduct>((json) => CheckoutProduct.fromJson(json)).toList();
}

class CheckoutProduct {
  final String CID;
  final String AID;
  final String PID;
  final String productAmount;
  final String price;
  final String title;
  final String image;
  final String taxable;
  final ItemSelectedCallback onItemSelected;

  CheckoutProduct({this.CID, this.AID, this.PID, this.productAmount, this.price, this.title, this.image, this.taxable, this.onItemSelected});

  factory CheckoutProduct.fromJson(Map<String, dynamic> json) {
    return CheckoutProduct(
      CID: json['CID'],
      AID: json['AID'],
      PID: json['PID'],
      productAmount: json['productAmount'],
      title: json['title'],
      price: json['price'],
      image: json['image'],
      taxable: json['taxable'],
    );
  }
}

class CheckoutProductList extends StatefulWidget {
  final List<CheckoutProduct> products;

/*  set totalPrice(value) {
    totalPrice = value;
  } */

//  get totalPrice => totalPrice;

  CheckoutProductList({Key key, this.products,}) : super(key: key);

  CheckoutProductState createState() => CheckoutProductState();
}

class CheckoutProductState extends State<CheckoutProductList> {
  static var totalPrice = 0.0;
  int quantity = 1;

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
      height: widget.products.length * 150.toDouble(),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: (widget.products.length == 1) ? 1 : widget.products.length,
        itemBuilder: (context, position) {
          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: Container(
              height: 120,
              child: Card(
                elevation: 10,
                child: InkWell(
                  splashColor: Colors.indigoAccent,
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
                                  image: NetworkImage((widget.products[position].image == null) ? 'https://nmcapstone.rssyn.com/wordpress/wp-content/uploads/2021/03/mobilecom_app_logo.png' : widget.products[position].image),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Container(margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10), height: 50, width: (isLargeScreen ? 540 : size.width * 0.56), child: Text(widget.products[position].title, style: TextStyle(fontSize: isLargeScreen ? 22.0 : 20.0, fontFamily: 'Montserrat Medium'), textAlign: TextAlign.start,)),
                              Container(
                                width: (isLargeScreen ? 540 : size.width * 0.64),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(alignment: Alignment.bottomLeft, child: Text((widget.products[position].price == '0.00' ? 'FREE' :   '\$' + widget.products[position].price), style: TextStyle(fontSize: isLargeScreen ? 18.0 : 17.0, fontFamily: 'Montserrat Medium', color: Colors.black.withOpacity(0.6)),)),
                                    Align(alignment: Alignment.bottomRight, child: Row(children: [                                    Text("Quantity:  ", style: TextStyle(fontFamily: 'Montserrat Medium', fontSize: isLargeScreen ? 18 : 15)),
                                      Container(
                                        height: 40,
                                        width: 25,
                                        child: Center(
                                          child: Text(widget.products[position].productAmount.toString()),
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