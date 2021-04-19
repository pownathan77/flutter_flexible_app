import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'DetailPage.dart';
import 'DetailWidget.dart';
import 'ListWidget.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  var isLargeScreen = false;
  var selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Your Orders"),
      ),
      body: OrientationBuilder(builder: (context, orientation) {

        if (MediaQuery.of(context).size.width > 600) {
          isLargeScreen = true;
        } else {
          isLargeScreen = false;
        }
        return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                  // TODO: This is where the code for changing the view is
                  Expanded(
                    flex: 2,
                    child: ListWidget(10, (value) {
                      if (isLargeScreen) {
                        selectedValue = value;
                        setState(() {});
                      } else {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return DetailPage(value, 0.01, 'assets/mobilecom_app_logo.png');
                          },
                        ));
                      }
                    }, 0.01, 'assets/mobilecom_app_logo.png'),
                  ),
                  // TODO: This is where the code for changing the view is
                  isLargeScreen ? Expanded(flex: 3, child: DetailWidget(selectedValue, 0.00, 'assets/mobilecom_app_logo.png')) : Container(),
                ]);
      }),
    );
  }
}