import 'package:flutter/material.dart';
import 'package:flutter_flexible_app/MainDrawer.dart';
import 'package:flutter_flexible_app/OrdersPage.dart';
import 'package:flutter_flexible_app/Registration.dart';
import 'AddressPage.dart';
import 'CheckoutList.dart';
import 'CheckoutPage.dart';
import 'MasterDetailPage.dart';
import 'OrientationDemo.dart';
import 'OrdersPage.dart';
import 'LoginPage.dart';
import 'CartPage.dart';
import 'AccountPage.dart';
import 'SettingsPage.dart';
import 'Registration.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.indigo,
      ),
      routes: {
      '/': (context) => LoginPage(),
        '/main': (context) => MasterDetailPage(),
      '/orders': (context) => OrdersPage(),
        '/cart': (context) => CartPage(),
        '/account': (context) => AccountPage(),
        '/settings': (context) => SettingsPage(),
        '/register': (context) => RegistrationPage(),
        '/new-address': (context) => AddressPage(),
        '/checkout': (context) => CheckoutPage(),
        '/confirm': (context) => CheckoutList(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

//https://gallery.flutter.dev/#/crane
//https://gallery.flutter.dev/#/
//https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade

