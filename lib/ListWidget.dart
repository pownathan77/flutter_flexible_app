import 'dart:convert';
import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

typedef Null ItemSelectedCallback(int value);

class ListWidget extends StatefulWidget {
  final int count;
  final double price;
  final String image;
  final ItemSelectedCallback onItemSelected;

  ListWidget(
    this.count,
    this.onItemSelected,
      this.price,
      this.image,
  );

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {

  @override
  Widget build(BuildContext context) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.count,
        itemBuilder: (context, position) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10,
              child: InkWell(
                splashColor: Colors.deepPurpleAccent,
                onTap: () {
                  widget.onItemSelected(position);
                },
                child: Row(
                  children: <Widget>[
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 8, 8, 8),
                          child: Container(
                              height: 90,
                              width: 90,
                              child: Image.asset('assets/flutter-logo.png')),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16.0, 10, 16, 5),
                              child: Text(position.toString(), style: TextStyle(fontSize: 24.0, fontFamily: 'Montserrat Medium'),),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 10),
                              child: Text(('0' == 0.00 ? 'FREE' :   '\$' + widget.price.toString()), style: TextStyle(fontSize: 18.0, fontFamily: 'Montserrat Medium', color: Colors.black.withOpacity(0.7)),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
  }
}
