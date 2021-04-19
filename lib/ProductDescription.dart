import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'FadeInVert.dart';

Future<AddToCart> addToCart(int pid, int aid, int quantity) async {
  print('addToCart: ' + pid.toString());
  print('addToCart AID: ' + aid.toString());
  print('addToCart quantity: ' + quantity.toString());
  final response = await http.post(Uri.https('nmcapstone.rssyn.com', 'Capstone-Backend/addtocart.php'),
    encoding: Encoding.getByName("utf-8"),
    body: <String, String>{
      'pid': pid.toString(),
      'aid': aid.toString(),
      'quantity': quantity.toString(),
    },
  );

  if (response.statusCode == 200) {
    return AddToCart.fromJson(jsonDecode(response.body));
  }
  else {
    throw Exception('Server error. Try again later.');
  }
}

Future<ProductDesc> productCheck(int pid, int aid) async {
  print('productCheck: ' + pid.toString());
  final response = await http.post(Uri.https('nmcapstone.rssyn.com', 'Capstone-Backend/productdetails.php'),
    encoding: Encoding.getByName("utf-8"),
    body: <String, String>{
      'pid': pid.toString(),
      'aid': aid.toString(),
    },
  );

  if (response.statusCode == 200) {
    return ProductDesc.fromJson(jsonDecode(response.body));
  }
  else {
    throw Exception('Server error. Try again later.');
  }
}

class AddToCart {
  final int CID;
  final int aid;
  final int pid;
  final int productAmount;

  AddToCart({this.CID, this.pid, this.aid, this.productAmount});

  factory AddToCart.fromJson(Map<String, dynamic> json) {
    return AddToCart(
      CID: json['CID'] as int,
      aid: json['aid'] as int,
      pid: json['pid'] as int,
      productAmount: json['productAmount'] as int,
    );
  }
}

class ProductDesc {
  final int aid;
  final int pid;
  final String price;
  final String title;
  final String category;
  final String productDescription;
  final String taxable;
  final String image;
  final int quantity;

  ProductDesc(
      {this.aid, this.pid, this.price, this.title, this.category, this.productDescription, this.image, this.quantity, this.taxable});

  factory ProductDesc.fromJson(Map<String, dynamic> json) {
    return ProductDesc(
      aid: json['aid'] as int,
      pid: json['pid'] as int,
      title: json['title'] as String,
      price: json['price'] as String,
      category: json['category'] as String,
      productDescription: json['product_description'] as String,
      taxable: json['product_description'] as String,
      image: json['image'] as String,
      quantity: json['quantity'] as int,
    );
  }
}

class ProductDescription extends StatefulWidget{
  final int aid;
  final int pid;

  ProductDescription({this.aid, this.pid});
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  Future<ProductDesc> _productDescription;
  Future<AddToCart> _addToCart;
  var isLargeScreen = false;

//  _ProductDescriptionState({Key key, this.productDescription}) : super(key: key);

  int quantity = 1;

  void _addQuantity() {
    if (quantity >= 1 && quantity < 99) {
      setState(() {
        quantity++;
      });
    }
    else if (quantity >= 99){

    }
    else {

    }
  }

  void _subtractQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
    else {
    }
  }
  
  @override
  void initState() {
    _productDescription = productCheck(widget.pid, widget.aid);
    print('InitState PID: ' + widget.pid.toString());
    print('InitState AID: ' + widget.aid.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if (MediaQuery.of(context).size.width > 900) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }

    return FutureBuilder<ProductDesc>(
      future: _productDescription,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Column(
                          children: <Widget>[
                            Container(
                              height: 85,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(width: 16),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(width: (isLargeScreen ? null : size.width * 0.85), child: Flexible(child: Text(snapshot.data.title, style: TextStyle(fontFamily: 'Montserrat Medium', color: Colors.black, fontSize: 30, )))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                    Container(
                      height: size.height * 0.4,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage((snapshot.data.image == null) ? 'https://nmcapstone.rssyn.com/wordpress/wp-content/uploads/2021/03/mobilecom_app_logo.png' : snapshot.data.image),
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(height: 20),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                            children: [
                              Flexible(
                                child: Text('Price: ' + (snapshot.data.price == '0' ? 'FREE' :   '\$' + snapshot.data.price), style: TextStyle(fontSize: 36.0, color: Colors.indigo, fontFamily: 'Montserrat Medium'),),
                              )

                            ]
                        ),
                        Wrap(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    SizedBox(width: size.width * 0.05),
                                    Text("Quantity:  ", style: TextStyle(fontFamily: 'Montserrat Medium', fontSize: 18)),
                                    TextButton(
                                      onPressed: _subtractQuantity,
                                      child: Icon(Icons.remove),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(30, 30),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 25,
                                      child: Center(
                                        child: Text('$quantity'),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: _addQuantity,
                                      child: Icon(Icons.add),
                                      style: ElevatedButton.styleFrom(
//                                  primary: Colors.blueAccent,
                                        minimumSize: Size(30, 30),
//                                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.05),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      addToCart(widget.pid, widget.aid, quantity);
                                      print('PID: ' + widget.pid.toString());
                                      print('AID: ' + widget.aid.toString());
                                      print('quantity: ' + quantity.toString());
                                      FutureBuilder<AddToCart>(
                                        future: _addToCart,
                                        builder: (context, confirm) {
                                          if (confirm.hasData) {
                                            return FadeInVert(
                                              0.2, AlertDialog(
                                              title: Text('Add to Cart Successful'),
                                              content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: [
                                                      Text(confirm.data.CID.toString()),
                                                      Container(
                                                        height: 5,
                                                      ),
                                                      Text('AID: ' + confirm.data.aid.toString() + 'PID: ' + confirm.data.pid.toString()),
                                                    ],
                                                  )
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: Text('Close'),
                                                  onPressed: () {
                                                    setState(() {

                                                    });
                                                  },
                                                )
                                              ],
                                            ),
                                            );
                                          }
                                          if (confirm.hasError) {
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
                                                      _addToCart = null;
                                                    });
                                                  },
                                                )
                                              ],
                                            ),
                                            );
                                          }
                                          return CircularProgressIndicator(strokeWidth: 50.0,);
                                        },
                                      );
                                    });
                                  },
                                  child: Text('Add to Cart'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.indigoAccent,
                                    textStyle: TextStyle(color: Colors.white, fontFamily: 'Montserrat Medium', fontSize: 24.0),
                                    minimumSize: Size(size.width * 0.25, size.height * 0.08),
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                  ),
                                ),
                              ),
                            ]

                        ),

                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          leading: Icon(Icons.category),
                          title: Text('Category:'),
                          subtitle: Text(snapshot.data.category),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Flexible(child: Text('About this item: ', style: TextStyle(fontSize: 24.0, fontFamily: 'Montserrat Medium'),)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Flexible(child: Text(snapshot.data.productDescription, style: TextStyle(fontSize: 18.0, fontFamily: 'Montserrat Medium'),)),
                          ],
                        ),
                      ],
                    ),
                  ),

                ),
              ],
            ),
          );
        }
        else if (snapshot.hasError) {
          return FadeInVert(
            0.2, AlertDialog(
            title: Text('Unable to log in'),
            content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text('Load failed'),
                    Container(
                      height: 5,
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
    );
  }
}