import 'package:flutter/material.dart';
import 'CartWidget.dart';
import 'package:http/http.dart' as http;

import 'FadeIn.dart';
import 'FadeInVert.dart';

class CartPage extends StatefulWidget {
  double _totalPrice;

  set totalPrice(value) {
    _totalPrice = value;
  }

  get totalPrice => _totalPrice;

  @override
  _CartPageState createState() => _CartPageState();
}

// TODO: This code just returns the Widget and adds an AppBar to it!
class _CartPageState extends State<CartPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {setState(() {
      //GOT THAT SET STATE BOIIII
    });});
  }

  @override
  Widget build(BuildContext context) {
    var _cartTotal = 0.0;
    final Map cartargs = ModalRoute.of(context).settings.arguments;
    var isLargeScreen = false;

    if (MediaQuery.of(context).size.width > 900) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
        elevation: 0,
      ),
      body:
          FutureBuilder<List<CartInventory>>(
            future: GetCart(cartargs['aid']),
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
                      Expanded(flex: 3, child: ListTile(leading: Icon(Icons.attach_money, color: Colors.white,), title: Text('Subtotal: ', style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),), subtitle: Text("\$" + widget.totalPrice.toString(), style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white.withOpacity(0.8))),)),
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