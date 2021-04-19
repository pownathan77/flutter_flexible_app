import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'DetailPage.dart';
import 'DetailWidget.dart';
import 'ListWidget.dart';

class Orders extends StatefulWidget {

  @override
  _MasterDetailOrdersState createState() => _MasterDetailOrdersState();
}

class _MasterDetailOrdersState extends State<Orders> {
  var isLargeScreen = false;
  var selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {

        if (MediaQuery.of(context).size.width > 600) {
          isLargeScreen = true;
        } else {
          isLargeScreen = false;
        }

        return Row(children: <Widget>[
          // TODO: This is where the code for changing the view is
          Expanded(
            flex: 1,
            child: ListWidget(30, (value) {
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
            }, 0.00, 'assets/mobilecom_app_logo.png'),
          ),
          // TODO: This is where the code for changing the view is
          isLargeScreen ? Expanded(flex: 3, child: DetailWidget(selectedValue, 0.01, 'assets/mobilecom_app_logo.png')) : Container(),
        ]);
      }),
    );
  }
}