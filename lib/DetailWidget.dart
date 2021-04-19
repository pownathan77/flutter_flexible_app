import 'package:flutter/material.dart';

class DetailWidget extends StatefulWidget {

  final int data;
  final double price;
  final String image;

  DetailWidget(
      this.data,
      this.price,
      this.image,
      );

  @override
  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  int quantity = 1;

  void _addQuantity() {
    if (quantity >= 1 && quantity < 99) {
      setState(() {
        quantity++;
      });
    }
    else if (quantity >= 99){

    }
    else {

    }
  }

  void _subtractQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
    else {
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                    children: <Widget>[
                      Container(
                        height: 64,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: 16),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(child: Text("You selected: Item " + widget.data.toString(), style: TextStyle(fontFamily: 'Montserrat Medium', color: Colors.black, fontSize: 30, ))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
              Container(
                height: size.height * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.image),
                    fit: BoxFit.scaleDown,
                  ),
                ),
      ),
      ],
          ),
          Divider(height: 20),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        Flexible(
                          child: Text('Price: ' + (widget.price == 0.00 ? 'FREE' :   '\$' + widget.price.toString()), style: TextStyle(fontSize: 36.0, color: Colors.purple, fontFamily: 'Montserrat Medium'),),
                        )

                     ]
                    ),
                    Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              SizedBox(width: size.width * 0.05),
                              Text("Quantity:  ", style: TextStyle(fontFamily: 'Montserrat Medium', fontSize: 18)),
                              TextButton(
                                onPressed: _subtractQuantity,
                                child: Icon(Icons.remove),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(30, 30),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 25,
                                child: Center(
                                  child: Text('$quantity'),
                                ),
                              ),
                              TextButton(
                                onPressed: _addQuantity,
                                child: Icon(Icons.add),
                                style: ElevatedButton.styleFrom(
//                                  primary: Colors.blueAccent,
                                  minimumSize: Size(30, 30),
//                                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
                                ),
                              ),
                              SizedBox(width: size.width * 0.05),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                //TODO: SET STATE OF ADD TO CART BUTTON
                              });
                            },
                            child: Text('Add to Cart'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurpleAccent,
                              textStyle: TextStyle(color: Colors.white, fontFamily: 'Montserrat Medium', fontSize: 24.0),
                              minimumSize: Size(size.width * 0.25, size.height * 0.08),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            ),
                          ),
                        ),
                      ]

                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Flexible(child: Text('About this item: ', style: TextStyle(fontSize: 24.0, fontFamily: 'Montserrat Medium'),)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(child: Text('This is a description, Wahoooooooooo! Every-a-body a-loves descriptions. Woopeeeeeeee! I am a the greatest developer to have ever existed. Oh NOOOOOOOOOOOO. No no no that cannot beeeeeeee. Woopeeeeeeeeeeeeeeee', style: TextStyle(fontSize: 18.0, fontFamily: 'Montserrat Medium'),)),
                      ],
                    ),
                  ],
                ),
            ),

          ),
        ],
      ),
    );
  }
}
