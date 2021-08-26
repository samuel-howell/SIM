import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:howell_capstone/src/res/custom-colors.dart';



class CreateScreen extends StatefulWidget {
@override
_CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen>{
  
Map data = {}; 


addData(){
  //TODO:  Add textControllers here to record String data to vars that can then be passed to JSON map below

  String name = "Iphone Pro";

  Map<String,dynamic> demoData = { // this is a JSON file that is inserted into the DB
    "name": name,
    "description" : "256GB-RED"
    };

  CollectionReference collectionReference = FirebaseFirestore.instance.collection('data');  //collectionReference var now referes to the "data" collection in Firestore
  collectionReference.add(demoData); 
}

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Screen'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation:0,
      ),

      body: Container(
        margin: EdgeInsets.symmetric(horizontal:20),
        child: Column(
          children: [
            SizedBox(height:30,),
            Text('Create Screen', textAlign: TextAlign.center),

            SizedBox(height:70,),
            MaterialButton(
              elevation: 0,
              minWidth: double.maxFinite,
              height: 50,
              onPressed: addData, //! This will crash if you run a mobile emulator, but if you run chrome or a physical device it works fine
              color: CustomColors.cblue,
              child: Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 10),
                  Text('Add Data')
                ]
              )
            )
          ]
       
        )
      )
    );
  }
}

//TODO: Good reference articles... https://medium.com/firebase-tips-tricks/how-to-use-cloud-firestore-in-flutter-9ea80593ca40 ... https://www.youtube.com/watch?v=lyZQa7hqoVY 