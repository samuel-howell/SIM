import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:howell_capstone/src/widgets/item-info-widget.dart';
import 'package:howell_capstone/src/widgets/line-chart-day/line-chart-widget-day.dart';
import 'package:howell_capstone/src/widgets/line-chart-month/line-chart-widget-month.dart';
import 'package:howell_capstone/src/widgets/line-chart-year/line-chart-widget-year.dart';

class ItemInfoScreen extends StatefulWidget {
  // by initializing the itemdocid, and then requiring it in the const below, you are effectivley making it a parameter
  final String itemDocID;

  const ItemInfoScreen({Key? key, required this.itemDocID})
      : super(
            key:
                key); // adding required itemDocId here will force us to pass a itemDocID to this page

  @override
  _ItemInfoScreenState createState() => _ItemInfoScreenState();
}

final auth = FirebaseAuth.instance;

final _tabs = <Widget>[
  Tab(text: 'INFO'),
  Tab(text: 'DAY'),
  Tab(text: 'MONTH'),
  Tab(text: 'YEAR'),
];

class _ItemInfoScreenState extends State<ItemInfoScreen> {
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: _tabs.length,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: _tabs),
          ),
          body: TabBarView(children: <Widget>[
            ItemInfoWidget(itemDocID: widget.itemDocID),
            LineChartWidgetDay(itemID: widget.itemDocID),
            LineChartWidgetMonth(itemID: widget.itemDocID),
            LineChartWidgetYear(itemID: widget.itemDocID),
          ])),
    );
  }
}
