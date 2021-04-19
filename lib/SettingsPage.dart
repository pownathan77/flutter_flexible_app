import 'package:cupertino_setting_control/cupertino_setting_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'FadeInVert.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

// TODO: This code just returns the Widget and adds an AppBar to it!
class _SettingsPageState extends State<SettingsPage> {
  var _taxExempt = false;

  @override
  Widget build(BuildContext context) {
    final Map settingargs = ModalRoute.of(context).settings.arguments;
    var size = MediaQuery
        .of(context)
        .size;
    var orientation = MediaQuery
        .of(context)
        .orientation;
    var isLargeScreen = false;

    if (size.width > 700) {
      isLargeScreen = true;
    }

    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: Text("Settings"),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
            ),
            SafeArea(child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(flex: 1, child: Container(
                    height: 40,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                      child: Icon(Icons.person))),
                  Flexible(flex: 1, child: Container(margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0), child: Text(settingargs['username'], style: TextStyle(color: Colors.white, fontSize: 24), textAlign: TextAlign.end,))),
                ],
              ),
            )),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Column(
                children: [
                  Container(
                    height: 130,
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 700),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Card(
                            elevation: 10.0,
                            child: SwitchListTile(
                                title: Text('Tax Exemption Status', style: TextStyle(color: Colors.indigo)),
                                value: _taxExempt, onChanged: (bool value) {
                              setState(() {
                                _taxExempt = value;
                              });
                            }
                            ),
                          ),
                        ),
/*                        SettingRow(
                          rowData: SettingsDropDownConfig(
                              title: 'Select Area',
                              choices: {
                                'PA': 'PA',
                                'NY': 'NY',
                                'FL': 'FL',
                                'CA': 'CA',
                              }),
//                  onSettingDataRowChange: ,

                        ),
                        SettingRow(
                          rowData: SettingsYesNoConfig(
                              initialValue: false, title: 'Tax Exemption'),
                          //onSettingDataRowChange: (result) {}
                        ), */
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}