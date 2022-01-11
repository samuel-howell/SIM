import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:universal_html/js.dart';

class LineData{
  String itemID;
  List<QuantityOverDay> quantityOverDay;


  LineData(this.itemID, this.quantityOverDay);
}





class QuantityOverDay{

//our flspot data has to be in the form <double, double>

  DateTime date; // firebase returns timestamp so I converted it to datetime, thein i convert it to millisecondsSinceEpoch.toDouble()
  double quantity;


  QuantityOverDay(this.date, this.quantity);



  @override
  String toString() {
    return '{ ${this.date}, ${this.quantity} }';
  }
}

