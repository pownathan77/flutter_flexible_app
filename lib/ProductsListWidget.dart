import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexible_app/ProductDescription.dart';
import 'package:http/http.dart' as http;

import 'ProductDescriptionPage.dart';

typedef Null ItemSelectedCallback(int value);

Future<List<Products>> fetchProducts(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://nmcapstone.rssyn.com/Capstone-Backend/productlist.php'));

  // Use the compute function to run parseProducts in a separate isolate.
  return compute(parseProducts, response.body);
}

// A function that converts a response body into a List<Products>.
List<Products> parseProducts(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<Products>((json) => Products.fromJson(json)).toList();
}

class Products {
  final String PID;
  final String price;
  final String title;
  final String image;
  final ItemSelectedCallback onItemSelected;

  Products({this.PID, this.price, this.title, this.image, this.onItemSelected});

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      title: json['title'] as String,
      price: json['price'] as String,
      PID: json['PID'] as String,
      image: json['image'] as String,
    );
  }
}

/* class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Products>>(
        future: fetchProducts(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ProductsList(products: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
} */

class ProductsList extends StatelessWidget {
  final List<Products> products;
  final int AID;

  ProductsList({Key key, this.products, this.AID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var isLargeScreen = false;

    if (MediaQuery.of(context).size.width > 900) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: products.length,
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
                  print('PID on click: ' + products[position].PID.toString());
                  print('AID on click: ' + AID.toString());
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ProductDescriptionPage(pid: int.parse(products[position].PID), aid: AID,);
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
                                  image: NetworkImage((products[position].image == null) ? 'https://nmcapstone.rssyn.com/wordpress/wp-content/uploads/2021/03/mobilecom_app_logo.png' : products[position].image),
                                ),
                              ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Container(margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10), height: 50, width: (isLargeScreen ? null: size.width * 0.56), child: Text(products[position].title, style: TextStyle(fontSize: 22.0, fontFamily: 'Montserrat Medium'), textAlign: TextAlign.start,)),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 10, 16, 10),
                              child: Align(alignment: Alignment.bottomLeft, child: Text((products[position].price == '0.00' ? 'FREE' :   '\$' + products[position].price), style: TextStyle(fontSize: 18.0, fontFamily: 'Montserrat Medium', color: Colors.black.withOpacity(0.6)),)),
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
}