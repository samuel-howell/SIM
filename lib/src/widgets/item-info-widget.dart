import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:howell_capstone/src/utilities/database.dart';

class ItemInfoWidget extends StatefulWidget {
    final String itemDocID;

  const ItemInfoWidget({ Key? key,  required this.itemDocID}) : super(key: key);

  @override
  _ItemInfoWidgetState createState() => _ItemInfoWidgetState();
}

final auth = FirebaseAuth.instance;


class _ItemInfoWidgetState extends State<ItemInfoWidget> {
  @override
  Widget build(BuildContext context) {
        String? currentUserID = auth.currentUser?.uid;

    return Scaffold(
          
          body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currentUserID)
                  .collection('stores')
                  .doc(Database().getCurrentStoreID())
                  .collection("items")
                  .doc(widget.itemDocID)
                  .snapshots(), // widget.itemDocId is the document id that was passed from the previous page.
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                DocumentSnapshot? userDocument = snapshot.data as DocumentSnapshot<
                    Object?>?;
                     // by casting to document snapshot, we can call .get and get the individual fields from the document.
                return Scaffold(
                  body: Align(
                    alignment: Alignment.topLeft,
                    // child: LayoutBuilder(
                    //   builder:
                    //       (BuildContext context, BoxConstraints constraints) {
                    //     return SingleChildScrollView(
                    //       child: Column(children: [
                    //         Row(children: [
                    //           Container(
                    //               height: constraints.maxHeight / 6,
                    //               width: MediaQuery.of(context).size.width,
                    //               color: Colors.red,
                                          
                    //               child: Column(
                    //                   mainAxisAlignment: MainAxisAlignment.center,
                    //                   children: [
                    //                     Text('Item Name:',
                    //                         style: GoogleFonts.lato(
                    //                             textStyle: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 20))),
                    //                     Text(userDocument!.get('name'),
                    //                         style: GoogleFonts.lato(
                    //                             textStyle: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 20))),
                    //                   ])),
                    //         ]),
                    //         Row(children: [
                    //           Container(
                    //               height: constraints.maxHeight / 6,
                    //               width: MediaQuery.of(context).size.width,
                    //               color: Colors.green,
                                          
                    //               child: Column(
                    //                   mainAxisAlignment: MainAxisAlignment.center,
                    //                   children: [
                    //                     Text('Last Employee to Interact:',
                    //                         style: GoogleFonts.lato(
                    //                             textStyle: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 20))),
                    //                     Text(
                    //                         userDocument
                    //                             .get('LastEmployeeToInteract'),
                    //                         style: GoogleFonts.lato(
                    //                             textStyle: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 20))),
                    //                   ])),
                    //         ]),
                    //         Row(children: [
                    //           Container(
                    //               height: constraints.maxHeight / 6,
                    //               width: MediaQuery.of(context).size.width,
                    //               color: Colors.red,
                                          
                    //               child: Column(
                    //                   mainAxisAlignment: MainAxisAlignment.center,
                    //                   children: [
                    //                     Expanded(
                    //                       child: Text('Most Recent Scan In:',
                    //                           style: GoogleFonts.lato(
                    //                               textStyle: TextStyle(
                    //                                   color: Colors.black,
                    //                                   fontSize: 20))),
                    //                     ),
                    //                     Expanded(
                    //                       child: Text(
                    //                           userDocument
                    //                               .get('mostRecentScanIn')
                    //                               .toString(),
                    //                           style: GoogleFonts.lato(
                    //                               textStyle: TextStyle(
                    //                                   color: Colors.black,
                    //                                   fontSize: 20))),
                    //                     ),
                                          
                    //                     SizedBox(height: 25,),
                                          
                    //                     Text('Most Recent Scan Out:',
                    //                         style: GoogleFonts.lato(
                    //                             textStyle: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 20))),
                    //                     Text(
                    //                         userDocument
                    //                             .get('mostRecentScanOut')
                    //                             .toString(),
                    //                         style: GoogleFonts.lato(
                    //                             textStyle: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 20))),
                    //                   ])),
                                      
                    //         ]),
                    //         Row(children: [
                    //           Container(
                    //               height: constraints.maxHeight / 4,
                    //               width: MediaQuery.of(context).size.width / 2,
                    //               color: Colors.orange,
                                          
                    //               child: Column(
                    //                   mainAxisAlignment: MainAxisAlignment.center,
                    //                   children: [
                    //                     Text('Item ID:',
                    //                         style: GoogleFonts.lato(
                    //                             textStyle: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 20))),
                    //                     Text(userDocument.get('id'),
                    //                         style: GoogleFonts.lato(
                    //                             textStyle: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 20))),
                    //                   ])),
                    //           Container(
                    //               height: constraints.maxHeight / 4,
                    //               width: MediaQuery.of(context).size.width / 2,
                    //               color: Colors.purple,
                                          
                    //               child: Column(
                    //                   mainAxisAlignment: MainAxisAlignment.center,
                    //                   children: [
                    //                     Text('Description:',
                    //                         style: GoogleFonts.lato(
                    //                             textStyle: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 20))),
                    //                     Text(userDocument.get('description'),
                    //                         style: GoogleFonts.lato(
                    //                             textStyle: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 20))),
                    //                   ])),
                    //         ]),
                    //         Row(children: [
                    //           Container(
                    //               height: constraints.maxHeight / 4,
                    //               width: MediaQuery.of(context).size.width / 2,
                    //               color: Colors.blue,
                                          
                    //               child: Column(
                    //                   mainAxisAlignment: MainAxisAlignment.center,
                    //                   children: [
                    //                     Text('Price:',
                    //                         style: GoogleFonts.lato(
                    //                             textStyle: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 20))),
                    //                     Text(userDocument.get('price').toString(),
                    //                         style: GoogleFonts.lato(
                    //                             textStyle: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 20))),
                    //                   ])),
                    //           Container(
                    //               height: constraints.maxHeight / 4,
                    //               width: MediaQuery.of(context).size.width / 2,
                    //               //color: Colors.blue,
                                          
                    //               child: Column(
                    //                   mainAxisAlignment: MainAxisAlignment.center,
                    //                   children: [
                    //                     Text('Quantity:',
                    //                         style: GoogleFonts.lato(
                    //                             textStyle: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 20))),
                    //                     Text(
                    //                         userDocument.get('quantity').toString(),
                    //                         style: GoogleFonts.lato(
                    //                             textStyle: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 20))),
                    //                   ])),
                    //         ]),
                                                            
                    //       ]),
                    //     );
                    //   },
                    // ),
                    child: Container(
                      decoration: const BoxDecoration(

                        gradient: LinearGradient(
                          colors: [
                            Color(0xffEF709B),
                            Color(0xffFA9372),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),


                      child: SingleChildScrollView(
                        child: Stack(
                          children: <Widget>[
                            Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const Text(
                                'Item Name: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(userDocument!.get('name'),
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25))),
                        
                              customDivider(context),

                              const Text(
                                'Price: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(userDocument.get('price').toString(),
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25))), 

                             customDivider(context),

                            const Text(
                                'Quantity: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(userDocument.get('quantity').toString(),
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25))), 

                              customDivider(context),

                              const Text(
                                'ID: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(userDocument.get('id'),
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25))), 
                      
                              customDivider(context),
         
                              const Text(
                                'Last Employee to Interact: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(userDocument.get('LastEmployeeToInteract'),
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25))),
                      
                              customDivider(context),
                      
                              const Text(
                                'Most Recent Scan In: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(userDocument.get('mostRecentScanIn'),
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.white,                        
                                                  fontSize: 25))),
                      
                              customDivider(context),
                      
                             const Text(
                                'Most Recent Scan Out: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(userDocument.get('mostRecentScanOut'),
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25))),      
                      
                              customDivider(context),
                      
                            
                      
                             const Text(
                                'Description: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(userDocument.get('description'),
                                          style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25))), 
                      
                             customDivider(context),
                      
                                                                                                                                  
                            ]
                            ),
                          ]
                        ),
                      )

                    )
                  ),
                );
              }
            )
          );
        }
      }

      Widget customDivider (BuildContext context){
        return Column(children: [

            SizedBox(height: 10),

            Divider(
            height: 20,
            thickness: 5,
            indent: 10,
            endIndent: 10,
            color: Colors.white,
          ),

            SizedBox(height: 10),

        ],);
      }