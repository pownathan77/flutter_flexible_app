import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'CartWidget.dart';
import 'CheckoutProductList.dart';
import 'FadeIn.dart';
import 'FadeInVert.dart';
import 'MasterDetailPage.dart';

Future<Purchase> getPurchase(String aid, subtotal, tax, total, address) async {
  final response = await http.post(Uri.https('nmcapstone.rssyn.com', 'Capstone-Backend/topurchase.php'),
    encoding: Encoding.getByName("utf-8"),
    body: <String, dynamic>{
      'aid': aid,
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'address': address,
    },
  );

  if (response.statusCode == 200) {
    return Purchase.fromJson(jsonDecode(response.body));
  }
  else {
    throw Exception('Server error. Try again later.');
  }
}

// TODO: Purchase constructor
class Purchase {
  final String AID;
  final String email;
  final String userPassword;
  final String username;
  final String fname;
  final String lname;
  final String phone;
  final String taxable;

  Purchase({this.email, this.userPassword, this.phone, this.fname, this.lname, this.username, this.AID, this.taxable});

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
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

Future<List<Product>> productCheck(int aid) async {
  print('productCheck: ' + aid.toString());
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
List<Product> parseCart(String responseBody) {
  final parsed = jsonDecode(responseBody);
  print(parsed);
  return parsed.map<Product>((json) => Product.fromJson(json)).toList();
}

class Product {
  final String CID;
  final String AID;
  final String PID;
  final String productAmount;
  final String price;
  final String title;
  final String image;
  final String taxable;

  Product({this.CID, this.AID, this.PID, this.productAmount, this.price, this.title, this.image, this.taxable});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
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

class CheckoutList extends StatefulWidget{
  final int aid;
  final String address_ID;
  final String stateAbbrv;
  final String city;
  final String zipCode;
  final String taxExempt;

  CheckoutList({this.aid, this.address_ID, this.zipCode, this.stateAbbrv, this.city, this.taxExempt});

  _CheckoutListState createState() => _CheckoutListState();
}

class _CheckoutListState extends State<CheckoutList> {
  Future<Purchase> _Purchase;
  var total = 0.00;
  var tax = 0.00;
  var isLargeScreen = false;

//  _ProductDescriptionState({Key key, this.productDescription}) : super(key: key);

  @override
  void initState() {
    Future.delayed(Duration.zero, () {setState(() {
      calculateTotal();
    });});
    print('InitState AID: ' + widget.aid.toString());
    super.initState();
  }

  void calculateTotal() {
    total = 0.00;
    CartInventoryState.totalPrice = CartInventoryState.totalPrice;
    if (widget.taxExempt.contains('Y')) {
      print(widget.taxExempt);
      tax = 0.00;
    }
    else {
      print(widget.taxExempt);
      tax = CartInventoryState.totalPrice * 0.3;
    }
    total = tax + CartInventoryState.totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    final Map checkoutargs = ModalRoute.of(context).settings.arguments;
    var size = MediaQuery
        .of(context)
        .size;

    if (MediaQuery
        .of(context)
        .size
        .width > 900) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Final Checkout'),
        elevation: 0.0,
      ),
      body: (_Purchase == null) ? FutureBuilder<List<CheckoutProduct>>(
        future: GetList(widget.aid),
        builder: (context, snapshot) {
          if (snapshot.hasError || snapshot.data == []) {
            print(snapshot.error);
            return FadeInVert(
              0.2, AlertDialog(
              title: Text('Unable to load cart'),
              content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text('Please try again later'),
                      Container(
                        height: 5,
                      ),
                      Text("Server error" + snapshot.error.toString()),
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
          };

          return snapshot.hasData
              ? (snapshot.data.isEmpty) ? Column(
            children: [
              SafeArea(child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 3, child: ListTile(leading: Icon(Icons.attach_money, color: Colors.white,), title: Text('Total: ', style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),), subtitle: Text("\$" + total.toStringAsFixed(2), style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white.withOpacity(0.8))),)),
                  ],
                ),
              ),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeIn(
                      1.0, Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Oh no, it looks like your cart is empty!', style: Theme.of(context).textTheme.headline4,),
                    ),
                    ),
                    FadeIn(
                        2.0, Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.remove_shopping_cart_outlined, color: Colors.indigo[300], size: isLargeScreen ? 200 : 50),
                    )
                    )
                  ]
              )
            ],
          )
              :
          SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(child: Container(
                    height: 80,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                    ),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 1000),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 3, child: ListTile(leading: Icon(Icons.subdirectory_arrow_right, color: Colors.amber[400],), title: Text((isLargeScreen ? 'Subtotal: ' : 'Sub: '), style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white.withOpacity(0.8)),), subtitle: Text('\$' + CartInventoryState.totalPrice.toString(), style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white.withOpacity(0.8))),)),
                          Expanded(flex: 3, child: ListTile(leading: Icon(Icons.attach_money, color: Colors.teal[400],), title: Text('Tax: ', style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white.withOpacity(0.8)),), subtitle: Text('\$' + tax.toStringAsFixed(2), style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white.withOpacity(0.8))),)),
                          Expanded(flex: 3, child: ListTile(leading: Icon(Icons.credit_card, color: Colors.red[400],), title: Text('Total: ', style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),), subtitle: Text('\$' + total.toStringAsFixed(2), style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white)),)),
                          Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FloatingActionButton(onPressed: () {setState(() {
                              _Purchase =
                                  getPurchase(widget.aid.toString(), CartInventoryState.totalPrice.toString(), tax.toString(), total.toString(), (widget.address_ID + ', '  + widget.city + ' ' + widget.stateAbbrv + ' ' + widget.zipCode));
                              print(_Purchase.toString());
//                        Navigator.pushNamed(context, '/main');
                            });}, child: Icon(Icons.navigate_next), elevation: 0, backgroundColor: Colors.indigo,),
                          )))
                        ],
                      ),
                    )
                ),
                ),
                Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FadeIn(1.0, Text('Delivering to: ', style: Theme.of(context).textTheme.headline5)),
                      Container(
                        height: 10,
                      ),
                      FadeIn(2.0, Text(widget.address_ID + " " + widget.city + ", " + widget.stateAbbrv + " " + widget.zipCode, style: Theme.of(context).textTheme.headline6,)),
                    ],
                  ),
                ),
                CheckoutProductList(products: snapshot.data),
              ],
            ),
          )


              : Center(child: CircularProgressIndicator());
        },
      ) : FutureBuilder<Purchase>(
          future: _Purchase,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.AID == widget.aid.toString()) {
                print('AID: ' + snapshot.data.AID.toString());
                return FadeInVert(
                  0.2, AlertDialog(
                  title: Text('Success!'),
                  content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Text('There is always more to enjoy, please stay tuned!'),
                        ],
                      )
                  ),
                  actions: [
                    TextButton(
                      child: Text('Continue'),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => MasterDetailPage(email: snapshot.data.email, username: snapshot.data.username, phone: snapshot.data.phone, lname: snapshot.data.lname, fname: snapshot.data.fname, aid: int.parse(snapshot.data.AID), tax: snapshot.data.taxable)));
                      },
                    )
                  ],
                ),
                );
              }
              else if (snapshot.data.email != widget.aid) {
                return FadeInVert(
                  0.2, AlertDialog(
                  title: Text('Unable to complete'),
                  content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Text('Server error'),
                          Container(
                            height: 5,
                          ),
                          Text("Please log in again to complete."),
                        ],
                      )
                  ),
                  actions: [
                    TextButton(
                      child: Text('Close'),
                      onPressed: () {
                        setState(() {
                          _Purchase = null;
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
                        Text(snapshot.error.toString()),
                      ],
                    )
                ),
                actions: [
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      setState(() {
                        _Purchase = null;
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
}