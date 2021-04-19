import 'package:flutter/material.dart';
import 'package:flutter_flexible_app/AccountPage.dart';

import 'LoginPage.dart';

class MainDrawer extends StatefulWidget {
  final String email;
  final String username;
  final String fname;
  final String lname;
  final String phone;

  MainDrawer({this.email, this.username, this.fname, this.lname, this.phone});

  @override
  _StateMainDrawer createState() => _StateMainDrawer();
}

class _StateMainDrawer extends State<MainDrawer> {
  var isLargeScreen = false;

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if (MediaQuery.of(context).size.width > 900) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }

    return Drawer(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Divider( color: Colors.transparent),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('https://bekey.io/static/images/flutter/flutter-logo.png'),
                          scale: 4.0,
                        ),
                      ),
                    ),
                    Divider(color: Colors.transparent,),
                    Text('Welcome, ' + widget.username, style: TextStyle(fontSize: 22, color: Colors.white)),
                    Text(widget.email, style: TextStyle(fontSize: 18, color: Colors.white)),
                    Divider(color: Colors.transparent),
                  ],
              )

              ),
            ),

            ListTile(
                leading: Icon(Icons.fastfood),
                title: Text('Orders'),
                onTap: () {
                  setState(() {
                    Navigator.pushNamed(context, '/orders');
                  });
                }
            ),
            ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Account'),
                onTap: () {
                  setState(() {
                    print('WIDGET.EMAIL: ' + widget.email);
                    Navigator.pushNamed(context, '/account', arguments: {'email' : widget.email, 'fname' : widget.fname, 'lname' : widget.lname, 'phone' : widget.phone, 'username' : widget.username});
                  });
                }
            ),
            ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  setState(() {
                    Navigator.pushNamed(context, '/settings', arguments: {'username' : widget.username});
                  });
                }
            ),
            Container(
              height: isLargeScreen ? size.height * 0.6 : size.height * 0.5,
            ),
            ListTile(
                leading: Icon(Icons.restaurant_menu),
                title: Text('Log out'),
                onTap: () {
                  setState(() {
                    Navigator.pushNamed(context, '/', arguments: {});
                  });
                }
            ),
          ],
        ),
      );
  }
}

class Arguments {
  final String email;

  Arguments(this.email);
}

