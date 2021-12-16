import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:universal_html/js.dart';

class LineData{
  String itemID;
  List<QuantityDaily> quantityDaily;


  LineData(this.itemID, this.quantityDaily);
}




class QuantityDaily{

  DateTime date; // firebase returns timestamp so I converted it to datetime over in to the database.dart file
  int quantity;


  QuantityDaily(this.date, this.quantity);



  @override
  String toString() {
    return '{ ${this.date}, ${this.quantity} }';
  }
}

