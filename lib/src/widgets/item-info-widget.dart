import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:howell_capstone/src/utilities/database.dart';

class ItemInfoWidget extends StatefulWidget {
  final String itemDocID;

  const ItemInfoWidget({Key? key, required this.itemDocID}) : super(key: key);

  @override
  _ItemInfoWidgetState createState() => _ItemInfoWidgetState();
}

final auth = FirebaseAuth.instance;

double storeTotalProfit = 1;

class _ItemInfoWidgetState extends State<ItemInfoWidget> {
  @override
  Widget build(BuildContext context) {
    String? currentUserID = auth.currentUser?.uid;

    //* this is how I assign a future to a var that I can actually use in the build
    //TODO: do this same method to pull in the name fo the store on the main page.
    //! I still have to comepletely exit and reenter the page before I see the new totalProfits.
    Database().getStoreTotalProfits().then((profit) {
      storeTotalProfit = profit;
      print('THE TOTAl STORE PROFIT IS ' + profit.toString());
    });

    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUserID)
                .collection('stores')
                .doc(Database().getCurrentStoreID())
                .collection("items")
                .doc(widget
                    .itemDocID) // widget.itemDocId is the document id that was passed from the previous page.
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              DocumentSnapshot? userDocument =
                  snapshot.data as DocumentSnapshot<Object?>?;
              // by casting to document snapshot, we can call .get and get the individual fields from the document.

              return Scaffold(
                  body: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          child: GridView.custom(
                        gridDelegate: SliverQuiltedGridDelegate(
                          crossAxisCount: 4,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          repeatPattern: QuiltedGridRepeatPattern.inverted,
                          pattern: [
                            QuiltedGridTile(2, 2),
                            QuiltedGridTile(1, 2),
                            //rQuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 2),
                          ],
                        ),
                        childrenDelegate:
                            SliverChildListDelegate(// using list delegate allows me to specifiy what exactly i want to pull from the firebase userDocument.
                                [
                          //* Some containers are empty an purely for asthetics.

                          Container(
                            margin: EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                color: Theme.of(context).colorScheme.primaryVariant,
                              ),
                              child: Center(
                                  child: Text(userDocument!.get('name'),
                                      style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.secondaryVariant)))),

                          Container(
                            margin: EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              child: Center(child: Text(''))),

                          Container(
                            margin: EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                color: Theme.of(context).colorScheme.primaryVariant,
                              ),
                              child: Center(
                                  child: Text(
                                      '\$' +
                                          userDocument.get('price').toString(),
                                      style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.secondaryVariant)))),

                          Container(
                            margin: EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                color: Theme.of(context).colorScheme.primaryVariant,
                              ),
                              child: Center(
                                  child: Text(
                                      userDocument
                                          .get('mostRecentScanIn')
                                          .toString(),
                                      style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.secondaryVariant)))),

                          Container(
                            margin: EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                color: Theme.of(context).colorScheme.primaryVariant,
                              ),
                              child: Center(
                                  child: Text(
                                      userDocument
                                          .get('LastEmployeeToInteract')
                                          .toString(),
                                      style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.secondaryVariant)))),

                          Container(
                            margin: EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                color: Theme.of(context).colorScheme.primaryVariant,
                              ),
                              child: Center(
                                  child: Text(
                                      userDocument
                                          .get('mostRecentScanOut')
                                          .toString(),
                                      style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.secondaryVariant)))),

                          Container(
                            margin: EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                color: Theme.of(context).colorScheme.primaryVariant,
                              ),
                              child: Center(
                                  child: Text(
                                      userDocument.get('quantity').toString(),
                                      style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.secondaryVariant)))),

                          Container(
                            margin: EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                color: Theme.of(context).colorScheme.primaryVariant,
                              ),
                              child: Center(
                                  child: Text(
                                      userDocument
                                          .get('description')
                                          .toString(),
                                      style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.secondaryVariant)))),

                          Container(
                            margin: EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              child: Center(child: Text(''))),

                          Container(
                            margin: EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                color: Theme.of(context).colorScheme.primaryVariant,
                              ),
                              child: Center(
                                  child: Text(userDocument.get('id').toString(),
                                      style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.secondaryVariant)))),

                          Container(
                            margin: EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              child: Center(child: Text(''))),

                          Container(
                            margin: EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              child: Center(child: Text(''))),
                        ]),
                      ))));

            
            }));
  }
}

Widget customDivider(BuildContext context) {
  return Column(
    children: [
      SizedBox(height: 10),
      Divider(
        height: 20,
        thickness: 5,
        indent: 10,
        endIndent: 10,
        color: Colors.white,
      ),
      SizedBox(height: 10),
    ],
  );
}
