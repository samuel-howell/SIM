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
      print('THE TOTAl STORE PROFIT IS ' + profit.toString());} );


    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(currentUserID)
                .collection('stores')
                .doc(Database().getCurrentStoreID())
                .collection("items")
                .doc(widget.itemDocID)     // widget.itemDocId is the document id that was passed from the previous page.
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
      QuiltedGridTile(1, 1),
      QuiltedGridTile(1, 1),
      QuiltedGridTile(1, 2),
    ],
  ),
  childrenDelegate: SliverChildListDelegate( // using list delegate allows me to specifiy what exactly i want to pull from the firebase userDocument.
    [
     
      
      Container(
        padding: const EdgeInsets.all(10.0,),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryVariant,
          border: Border.all(color: Colors.red), 
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          borderRadius: BorderRadius.all(new Radius.circular(10.0)),
          ), 
        child: Center(
          child: Text(userDocument!.get('name'), 
                  style: TextStyle(fontSize: 25)))
        ),

      Container(decoration: BoxDecoration(border: Border.all(color: Colors.red)), child: Text(userDocument.get('price').toString())),
      Container(decoration: BoxDecoration(border: Border.all(color: Colors.red)), child: Text(userDocument.get('quantity').toString())),
      Container(decoration: BoxDecoration(border: Border.all(color: Colors.red)), child: Text(userDocument.get('id'))),
      Container(decoration: BoxDecoration(border: Border.all(color: Colors.red)), child: Text(userDocument.get('LastEmployeeToInteract'))),
      Container(decoration: BoxDecoration(border: Border.all(color: Colors.red)), child: Text(userDocument.get('mostRecentScanIn'))),
      Container(decoration: BoxDecoration(border: Border.all(color: Colors.red)), child: Text(userDocument.get('mostRecentScanOut'))),
      Container(decoration: BoxDecoration(border: Border.all(color: Colors.red)), child: Text(userDocument.get('description'))),

      

    ]
    
  ),
))));





                        // child: SingleChildScrollView(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Stack(children: <Widget>[
                        //       Column(
                        //           crossAxisAlignment:
                        //               CrossAxisAlignment.stretch,
                        //           children: <Widget>[
                        //             const Text(
                        //               'Item Name: ',
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 25,
                        //                 fontWeight: FontWeight.bold,
                        //                 letterSpacing: 2,
                        //               ),
                        //               textAlign: TextAlign.left,
                        //             ),
                        //             Text(userDocument!.get('name'),
                        //                 style: GoogleFonts.lato(
                        //                     textStyle: TextStyle(
                        //                         color: Colors.white,
                        //                         fontSize: 25))),
                        //             customDivider(context),
                        //             const Text(
                        //               'Price: ',
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 25,
                        //                 fontWeight: FontWeight.bold,
                        //                 letterSpacing: 2,
                        //               ),
                        //               textAlign: TextAlign.left,
                        //             ),
                        //             Text(
                        //                 "\$ " +
                        //                     userDocument
                        //                         .get('price')
                        //                         .toString(),
                        //                 style: GoogleFonts.lato(
                        //                     textStyle: TextStyle(
                        //                         color: Colors.white,
                        //                         fontSize: 25))),
                        //             customDivider(context),


                        //             const Text(
                        //               'Store Total Profits: ',
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 25,
                        //                 fontWeight: FontWeight.bold,
                        //                 letterSpacing: 2,
                        //               ),
                        //               textAlign: TextAlign.left,
                        //             ),
                        //             Text(
                        //                 storeTotalProfit.toString(),
                        //                 style: GoogleFonts.lato(
                        //                     textStyle: TextStyle(
                        //                         color: Colors.white,
                        //                         fontSize: 25))),
                        //             customDivider(context),




                        //             const Text(

                        //               'Quantity: ',
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 25,
                        //                 fontWeight: FontWeight.bold,
                        //                 letterSpacing: 2,
                        //               ),
                        //               textAlign: TextAlign.left,
                        //             ),
                        //             Text(
                        //                 userDocument.get('quantity').toString(),
                        //                 style: GoogleFonts.lato(
                        //                     textStyle: TextStyle(
                        //                         color: Colors.white,
                        //                         fontSize: 25))),
                        //             customDivider(context),
                        //             const Text(
                        //               'ID: ',
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 25,
                        //                 fontWeight: FontWeight.bold,
                        //                 letterSpacing: 2,
                        //               ),
                        //               textAlign: TextAlign.left,
                        //             ),
                        //             Text(userDocument.get('id'),
                        //                 style: GoogleFonts.lato(
                        //                     textStyle: TextStyle(
                        //                         color: Colors.white,
                        //                         fontSize: 25))),
                        //             customDivider(context),
                        //             const Text(
                        //               'Last Employee to Interact: ',
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 25,
                        //                 fontWeight: FontWeight.bold,
                        //                 letterSpacing: 2,
                        //               ),
                        //               textAlign: TextAlign.left,
                        //             ),
                        //             Text(
                        //                 userDocument
                        //                     .get('LastEmployeeToInteract'),
                        //                 style: GoogleFonts.lato(
                        //                     textStyle: TextStyle(
                        //                         color: Colors.white,
                        //                         fontSize: 25))),
                        //             customDivider(context),
                        //             const Text(
                        //               'Most Recent Scan In: ',
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 25,
                        //                 fontWeight: FontWeight.bold,
                        //                 letterSpacing: 2,
                        //               ),
                        //               textAlign: TextAlign.left,
                        //             ),
                        //             Text(userDocument.get('mostRecentScanIn'),
                        //                 style: GoogleFonts.lato(
                        //                     textStyle: TextStyle(
                        //                         color: Colors.white,
                        //                         fontSize: 25))),
                        //             customDivider(context),
                        //             const Text(
                        //               'Most Recent Scan Out: ',
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 25,
                        //                 fontWeight: FontWeight.bold,
                        //                 letterSpacing: 2,
                        //               ),
                        //               textAlign: TextAlign.left,
                        //             ),
                        //             Text(userDocument.get('mostRecentScanOut'),
                        //                 style: GoogleFonts.lato(
                        //                     textStyle: TextStyle(
                        //                         color: Colors.white,
                        //                         fontSize: 25))),
                        //             customDivider(context),
                        //             const Text(
                        //               'Description: ',
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 25,
                        //                 fontWeight: FontWeight.bold,
                        //                 letterSpacing: 2,
                        //               ),
                        //               textAlign: TextAlign.left,
                        //             ),
                        //             Text(userDocument.get('description'),
                        //                 style: GoogleFonts.lato(
                        //                     textStyle: TextStyle(
                        //                         color: Colors.white,
                        //                         fontSize: 25))),
                        //             customDivider(context),
                        //           ]),
                        //     ]),
                        //   ),
                        // )


                        
//                         )),
                        
//               );
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
