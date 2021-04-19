import 'package:flutter/material.dart';
import 'package:flutter_flexible_app/ProductDescription.dart';

class ProductDescriptionPage extends StatefulWidget {
  final int pid;
  final int aid;

  ProductDescriptionPage({this.pid, @required this.aid});

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Details"),
      ),
      body: ProductDescription(pid: widget.pid, aid: widget.aid,),
    );
  }
}