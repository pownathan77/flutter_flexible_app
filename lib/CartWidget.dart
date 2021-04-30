import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'DetailWidget.dart';
import 'CartPage.dart';
import 'package:http/http.dart' as http;

import 'ProductDescriptionPage.dart';

typedef Null ItemSelectedCallback(int value);

Future<DeleteCart> cartDelete(String AID, PID) async {
  final response = await http.post(Uri.https('nmcapstone.rssyn.com', 'Capstone-Backend/removefromcart.php'),
    encoding: Encoding.getByName("utf-8"),
    body: <String, String>{
      'AID' : AID,
      'PID' : PID,
    },
  );

  if (response.statusCode == 200) {
    return DeleteCart.fromJson(jsonDecode(response.body));
  }
  else {
    throw Exception('Server error. Try again later.');
  }
}

// TODO: DeleteCart constructor
class DeleteCart {
  final String AID;
  final String email;
  final String userPassword;
  final String username;
  final String fname;
  final String lname;
  final String phone;

  DeleteCart({this.email, this.userPassword, this.phone, this.fname, this.lname, this.username, this.AID});

  factory DeleteCart.fromJson(Map<String, dynamic> json) {
    return DeleteCart(
      AID: json['AID'],
      email: json['email'],
      userPassword: json['userPassword'],
      username: json['username'],
      fname: json['fname'],
      lname: json['lname'],
      phone: json['phone'],
    );
  }
}

Future<List<CartInventory>> GetCart(int aid) async {
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
List<CartInventory> parseCart(String responseBody) {
  final parsed = jsonDecode(responseBody);
  print(parsed);
  return parsed.map<CartInventory>((json) => CartInventory.fromJson(json)).toList();
}

class CartInventory {
  final String CID;
  final String AID;
  final String PID;
  final String productAmount;
  final String price;
  final String title;
  final String image;
  final String taxable;
  final ItemSelectedCallback onItemSelected;

  CartInventory({this.CID, this.AID, this.PID, this.productAmount, this.price, this.title, this.image, this.taxable, this.onItemSelected});

  factory CartInventory.fromJson(Map<String, dynamic> json) {
    return CartInventory(
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

class CartInventoryList extends StatefulWidget {
  final List<CartInventory> products;

  CartInventoryList({Key key, this.products,}) : super(key: key);

  CartInventoryState createState() => CartInventoryState();
}

class CartInventoryState extends State<CartInventoryList> {
  static var totalPrice = 0.00;
  int quantity = 1;

  void changeTotal() {
    CartInventoryState.totalPrice = 0;
    if (widget.products.length == 0) {
      print('List is empty');
      CartInventoryState.totalPrice = 0.00;
    }
    else {
      for (var i = 0; i < widget.products.length; i++) {
        CartInventoryState.totalPrice +=
            double.parse(widget.products[i].price) *
                int.parse(widget.products[i].productAmount);
        print('Price in for loop' + widget.products[i].price);
      }
    }
  }

  @override
  void initState() {
    changeTotal();
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
                  onTap: () {
                    print('PID on click: ' + widget.products[position].PID.toString());
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ProductDescriptionPage(pid: int.parse(widget.products[position].PID));
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
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              cartDelete(widget.products[position].AID, widget.products[position].PID);
                                              Future.delayed(Duration(milliseconds: 3000), () {setState(() {
                                                initState();
                                              });});
                                            });
                                          },
                                          child: Icon(Icons.delete_outline),
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
//                                  primary: Colors.blueAccent,
                                            minimumSize: Size(20, 20),
//                                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
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