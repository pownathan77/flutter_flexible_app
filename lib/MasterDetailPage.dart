import 'package:flutter/material.dart';
import 'DetailPage.dart';
import 'DetailWidget.dart';
import 'MainDrawer.dart';
import 'MasterDetailOrdersPage.dart';
import 'package:http/http.dart' as http;

import 'ProductDescription.dart';
import 'ProductsListWidget.dart';

class MasterDetailPage extends StatefulWidget {
  final int aid;
  final String email;
  final String username;
  final String fname;
  final String lname;
  final String phone;

  MasterDetailPage({@required this.aid, this.email, this.username, this.fname, this.lname, this.phone});
  @override
  _MasterDetailPageState createState() => _MasterDetailPageState();
}

class _MasterDetailPageState extends State<MasterDetailPage> {
  var selectedValue = 0;
  var isLargeScreen = false;


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return widget.email == null ? Navigator.pushNamed(context, '/', arguments: {}) : Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: Text("Mobilecom"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.shopping_cart),
              tooltip: 'Check your cart!',
              onPressed: () {
                setState(() {
                  Navigator.pushNamed(context, '/cart', arguments: {'aid': widget.aid});
                });
              }),
          Text('   '),
        ],
      ),
      drawer: MainDrawer(email: widget.email, username: widget.username, fname: widget.fname, lname: widget.lname, phone: widget.phone,),
      body: OrientationBuilder(builder: (context, orientation) {

        if (MediaQuery.of(context).size.width > 900) {
          isLargeScreen = true;
        } else {
          isLargeScreen = false;
        }

        return Row(children: <Widget>[
          // TODO: This is where the code for changing the view is
          Expanded(
            flex: 2,
            child: FutureBuilder<List<Products>>(
              future: fetchProducts(http.Client()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? ProductsList(products: snapshot.data, AID: widget.aid)
                    : Center(child: CircularProgressIndicator());
              },
            ),
                  ),
          // TODO: This is where the code for changing the view is
          isLargeScreen ? Expanded(flex: 3, child: ProductDescription(pid: 1, aid: widget.aid)) : Container(),
        ]);
      }),
    );
  }
}

