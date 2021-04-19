import 'package:flutter/material.dart';
import 'DetailWidget.dart';
class DetailPage extends StatefulWidget {

  final int data;
  final double price;
  final String image;

  DetailPage(
      this.data,
      this.price,
      this.image,
      );

  @override
  _DetailPageState createState() => _DetailPageState();
}

// TODO: This code just returns the Widget and adds an AppBar to it!
class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Go Back"),
      ),
      body: DetailWidget(widget.data, widget.price, widget.image),
    );
  }
}
