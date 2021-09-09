import 'package:flutter/material.dart';
import 'package:howell_capstone/src/res/custom-colors.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:intl/intl.dart';




// Define a custom Form widget.
class AddItemForm extends StatefulWidget {
  const AddItemForm({Key? key}) : super(key: key);

  @override
  AddItemFormState createState() {
    return AddItemFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class AddItemFormState extends State<AddItemForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  //  these controllers will store the data inputed by the user.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _scanInController = TextEditingController();

  //quick calculation of the current date for mostRecentScanIn section in the Firestore DB using the intl package for date formatting
  String _currentDateTime = DateFormat.yMEd().add_jms().format(DateTime.now());



  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.

          //text field for item name
          TextFormField(
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter the item\'s name',
            ),


            controller: _nameController,
            keyboardType: TextInputType.text,
           

            validator: (value) { // The validator receives the text that the user has entered.
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),

          // text field for item description
          TextFormField(
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter the item\'s description',
            ),

            controller: _descriptionController,
            keyboardType: TextInputType.text, 

            validator: (value) { // The validator receives the text that the user has entered.
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),

          // text field for item price
          TextFormField(
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter the item\'s price',
            ),

            controller: _priceController,
            keyboardType: TextInputType.number,
              

          
            validator: (value) { // The validator receives the text that the user has entered.
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),

          // text field for quantity
          TextFormField(
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter the item\'s quantity',
            ),

            controller: _quantityController,
            keyboardType: TextInputType.number,
              

          
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
                        CustomColors.cpink,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        
                        setState(() {
                            _isProcessing = true;
                        });

                        await Database.addItem(
                          name: _nameController.text,
                          description: _descriptionController.text,
                          price: _priceController.text,
                          quantity: _quantityController.text,
                          mostRecentScanIn: _currentDateTime,  // pulls from the  _currentDateTime var created above.
                        );
                        
                        setState(() {
                          _isProcessing = false;
                        });

                        Navigator.of(context).pop(); // return to previous screen after operation is complete
                      }
                    },
                    child: const Text('Submit'),
                  ),
            )
        ],
      ),
    );
  }
}