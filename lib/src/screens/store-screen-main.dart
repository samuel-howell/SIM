
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:howell_capstone/src/screens/nav-drawer-screen.dart';
import 'package:howell_capstone/src/screens/store-csv-import.dart';

import 'package:howell_capstone/src/screens/store-screen-createdBy.dart';
import 'package:howell_capstone/src/screens/store-screen-sharedWith.dart';
import 'package:howell_capstone/src/utilities/SIMPL-export.dart';
import 'package:howell_capstone/src/widgets/custom-alert-dialogs.dart';


class StoreScreenMain extends StatefulWidget {
 

  const StoreScreenMain({Key? key})
      : super(
            key:
                key); // adding required itemDocId here will force us to pass a itemDocID to this page

  @override
  _StoreScreenMainState createState() => _StoreScreenMainState();
}

final auth = FirebaseAuth.instance;

final _tabs = <Widget>[
  Tab(text: 'OWNED'),
  Tab(text: 'SHARED'),
];

class _StoreScreenMainState extends State<StoreScreenMain> {
  @override
  Widget build(BuildContext context) {
        // this is the helper method for the popup menu button
    void onSelected(BuildContext context, int item) async {
      switch (item) {
        case 0:
          showAddStoreDialog(context);
          break;

        case 1:
          SIMPLExport().exportStoreCsv();
          break;

        case 2:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StoreCsvImport(),
          )); 
        break;
      }
    }


    return  DefaultTabController(
      length: _tabs.length,
      initialIndex: 0,
      child: Scaffold(
          drawer: NavigationDrawerWidget(),
          appBar: AppBar(
            actions: [
            PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
                  PopupMenuItem(child: Text('Add New Store'), value:0),
                  PopupMenuItem(child: Text('Export Stores'), value: 1),
                  PopupMenuItem(child: Text('Import Stores'), value: 2),
                ])
                      ],
            bottom: TabBar(tabs: _tabs),
          ),
          body: TabBarView(children: <Widget>[
            StoreScreenCreatedBy(),
            StoreScreenSharedWith(),
          ])),
  
    );
  }
}