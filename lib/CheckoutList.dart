import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'CartWidget.dart';
import 'FadeIn.dart';
import 'FadeInVert.dart';

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

  CheckoutList({this.aid, this.address_ID, this.zipCode, this.stateAbbrv, this.city});

  _CheckoutListState createState() => _CheckoutListState();
}

class _CheckoutListState extends State<CheckoutList> {
  var isLargeScreen = false;

//  _ProductDescriptionState({Key key, this.productDescription}) : super(key: key);

  @override
  void initState() {
    print('InitState AID: ' + widget.aid.toString());
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {setState(() {
      CartInventoryState.totalPrice = CartInventoryState.totalPrice - (CartInventoryState.totalPrice*0.5);
    });});
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
      body: FutureBuilder<List<CartInventory>>(
        future: GetCart(widget.aid),
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
                    Expanded(flex: 3, child: ListTile(leading: Icon(Icons.attach_money, color: Colors.white,), title: Text('Total: ', style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),), subtitle: Text("\$" + (CartInventoryState.totalPrice * 1.3).toString(), style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white.withOpacity(0.8))),)),
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
              : SingleChildScrollView(
            child: Column(
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
                        Expanded(flex: 3, child: ListTile(leading: Icon(Icons.attach_money, color: Colors.white,), title: Text('Subtotal: ', style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),), subtitle: Text(CartInventoryState.totalPrice.toString(), style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white.withOpacity(0.8))),)),
                        Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: FloatingActionButton(onPressed: () {Navigator.pushNamed(context, '/checkout', arguments: {'aid': snapshot.data[0].AID});}, child: Icon(Icons.next_week), elevation: 0, backgroundColor: Colors.indigo,),
                        )))
                      ],
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
                CartInventoryList(products: snapshot.data),
              ],
            ),
          )


              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}