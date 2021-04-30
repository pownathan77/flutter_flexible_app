import 'package:flutter/material.dart';
import 'CartWidget.dart';
import 'OrdersWidget.dart';
import 'package:http/http.dart' as http;

import 'FadeIn.dart';
import 'FadeInVert.dart';

class OrdersPage extends StatefulWidget {

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

// TODO: This code just returns the Widget and adds an AppBar to it!
class _OrdersPageState extends State<OrdersPage> {

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
    final Map orderargs = ModalRoute.of(context).settings.arguments;
    var isLargeScreen = false;

    if (MediaQuery.of(context).size.width > 900) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
        elevation: 0,
      ),
      body:
      FutureBuilder<List<OrdersInventory>>(
        future: GetOrders(orderargs['aid']),
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
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeIn(
                        1.0, Padding(
                        padding: const EdgeInsets.fromLTRB(8, 32, 8, 16),
                        child: Text('Looks kinda empty in here...', style: Theme.of(context).textTheme.headline4,),
                      ),
                      ),
                      FadeIn(
                          2.0, Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(Icons.cloud_off, color: Colors.indigo[300], size: isLargeScreen ? 200 : 50),
                      )
                      )
                    ]
                ),
              )
            ],
          )
              : SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OrdersInventoryList(orders: snapshot.data),
                ],
              ),
            ),
          )


              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}