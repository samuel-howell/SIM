import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howell_capstone/src/res/custom-colors.dart';
import 'package:howell_capstone/src/widgets/add-item-form.dart';

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Item Form'),
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              SizedBox(
                height: 30,
              ),
              Text('Add Item Form', textAlign: TextAlign.center),
              SizedBox(
                height: 70,
              ),
              AddItemForm(),
            ])));
  }
}
