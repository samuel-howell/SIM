import 'package:flutter/material.dart';
import 'package:howell_capstone/src/res/custom-colors.dart';
import 'package:howell_capstone/src/utilities/database.dart';


//TODONOTE: !!!!!!!  ITEMS need to be placed under store id in the firebase database. it need s to go like user --> store-->item

class StoreScreen extends StatefulWidget {

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store Screen'),
        centerTitle: true,
        backgroundColor: Colors.black
      ),

    floatingActionButton: FloatingActionButton(  
      child: Icon(Icons.post_add),  
      backgroundColor: Colors.green,  
      foregroundColor: Colors.white,  
      onPressed: () => {
      _addStoreDialog(context)
      },  
  
      ),  
    );
  }
}


final TextEditingController _storeNameController = TextEditingController();
final TextEditingController _storeAddressController = TextEditingController();

bool _isProcessing = false;


//TODO: Migrate this _addStoreDialog widget to the widgets folder, then import it into this page. kind of like you diud with the add item form. for refactoring.
//this alert dialog will pop up when the user clicks the "add database" floating action button
Future<void> _addStoreDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState)  {
        return AlertDialog(
          title: const Text('Add a new Store'),
          content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //text field for store name
              TextFormField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter the store\'s name',
                ),


                controller: _storeNameController,
                keyboardType: TextInputType.text,
              

                validator: (value) { // The validator receives the text that the user has entered.
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),

            //text field for store address
              TextFormField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter the store\'s address',
                ),


                controller: _storeAddressController,
                keyboardType: TextInputType.text,
              

                validator: (value) { // The validator receives the text that the user has entered.
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
          
              _isProcessing
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CustomColors.cblue,
                        ),
                      ),
                    )
                  : Container(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            CustomColors.cyellow,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                              _isProcessing = true;
                          });

                          await Database.addStore( //TODO: After the store is added, rebuild the listview on the database screen page to show the new store
                            name: _storeNameController.text,
                            address: _storeAddressController.text,
                          );
                          
                          setState(() {
                            _isProcessing = false;
                          });

                          Navigator.of(context).pop(); // return to previous screen after operation is complete
                          }
                        ,
                        child: const Text('Submit'),
                      ),
                )
            ],
          ),
          )
      );
    }  
  );
  }
);
}



  //TODO: for reference on alert dialog - https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/