import 'package:flutter/material.dart';
import 'package:flutter_flexible_app/FadeIn.dart';
import 'package:simple_animations/simple_animations.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

// TODO: This code just returns the Widget and adds an AppBar to it!
class _AccountPageState extends State<AccountPage> {

  @override
  Widget build(BuildContext context) {
    final Map account = ModalRoute.of(context).settings.arguments;
    print(account);

    var size = MediaQuery.of(context).size;
    var isLargeScreen = false;

    if (MediaQuery.of(context).size.width > 900) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }

    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: Text("Account Information"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color(0xff360033),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [Container(
            child: Column(
              children: [
                Container(
                  height: 215,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(isLargeScreen ? 30.0 : 15.0), bottomRight: Radius.circular(isLargeScreen ? 30.0 : 15.0)),
                gradient: LinearGradient(
                  tileMode: TileMode.mirror,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff360033),
                    Color(0xff0b8793),
                  ],
                  stops: [
                    0.2,
                    1.0,
                  ],
                ),
                backgroundBlendMode: BlendMode.srcOver,
              ),
              child: PlasmaRenderer(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 46.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_circle, size: 50.0, color: Colors.white,),
                        Text('  Your Account  ', style: TextStyle(fontSize: 40, color: Colors.white,)),
                      ],
                    ),
                  ),
                ),
                type: PlasmaType.bubbles,
                particles: 10,
                color: Color(0x44203a43),
                blur: 0.4,
                size: 1,
                speed: 1,
                offset: 0,
                blendMode: BlendMode.plus,
                variation1: 0,
                variation2: 0,
                variation3: 0,
                rotation: 0,
              ),
                ),
                ],
                ),
          ),
                Column(
                  children: [
                    Container(height: 150),
                    FadeIn(
                      1.0, Container(
                        constraints: BoxConstraints(maxWidth: 700.0),
                        height: isLargeScreen ? size.height * 0.15 : 120,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 5,
                            child: InkWell(
                              child: Center(child: ListTile(leading: Icon(Icons.account_circle, size: 50.0, color: Colors.indigoAccent[200]), title: Text('Account Owner', style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black.withOpacity(0.6)),), subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(account['fname'] + " " + account['lname'], style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black.withOpacity(0.8)),),
                              ),)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    FadeIn(
                      1.6, Container(
                      constraints: BoxConstraints(maxWidth: 700.0),
                      height: isLargeScreen ? size.height * 0.15 : 120,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          child: InkWell(
                            child: Center(child: ListTile(leading: Icon(Icons.text_fields, size: 50.0, color: Colors.amber[400],), title: Text('Username', style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black.withOpacity(0.6))), subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(account['username'], style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black.withOpacity(0.8)),),
                            ),)),
                          ),
                        ),
                      ),
                    ),
                    ),
                    FadeIn(
                      2.2, Container(
                      constraints: BoxConstraints(maxWidth: 700.0),
                      height: isLargeScreen ? size.height * 0.15 : 120,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          child: InkWell(
                            child: Center(child: ListTile(leading: Icon(Icons.alternate_email, size: 50.0, color: Colors.teal[400],), title: Text('Email Address', style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black.withOpacity(0.6))), subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(account['email'], style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black.withOpacity(0.8)),),
                            ),)),
                          ),
                        ),
                      ),
                    ),
                    ),
                    FadeIn(
                      2.8, Container(
                      constraints: BoxConstraints(maxWidth: 700.0),
                      height: isLargeScreen ? size.height * 0.15 : 120,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          child: InkWell(
                            child: Center(child: ListTile(leading: Icon(Icons.phone, size: 50.0, color: Colors.red[400],), title: Text('Phone Number', style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.black.withOpacity(0.6)),), subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(account['phone'], style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.black.withOpacity(0.8)),),
                            ),)),
                          ),
                        ),
                      ),
                    ),
                    ),
                  ],
                ),
              ],
            ),
      ),
        );
  }
}