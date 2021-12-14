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
  final TextEditingController _idController = TextEditingController();

  //quick calculation of the current date for mostRecentScanIn section in the Firestore DB using the intl package for date formatting
  String _currentDateTime = DateFormat.yMEd().add_jms().format(DateTime.now());

  // this regex pattern will only accept numbers
  RegExp numbersOnlyRegex = RegExp(r'[0-9]');
  RegExp numbersTextHyphenRegex = RegExp(r'[a-zA-Z0-9 -]');

  //*really good article on validation - https://michaeladesola1410.medium.com/input-validation-flutter-dfe433caec5c

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,

      // wrapping in expanded, container, and listview prevents overflow
      child: Expanded(
        child: Container(
          child: ListView(
            shrinkWrap: true,
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
                validator: (value) {
                  // The validator receives the text that the user has entered.
                  if (value == null || value.isEmpty) {
                    //TODO: put a regex here that can accept str like "IPHONE-11-red (2021)", but not sql injection type of stuff.  apply same regex at all similar fields.
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
                validator: (value) {
                  // The validator receives the text that the user has entered.
                  if (value == null || value.isEmpty) {
                    return 'Please enter some valid text';
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
                validator: (value) {
                  // The validator receives the text that the user has entered.

                  //* way 1 of declaring a regex
                  RegExp regex = new RegExp(
                      r'[0-9]'); //!:  allows ` . its should not allow that character. shouldn't be a problem on phones tho, since they will only have access to number keyboard.
                  if (!regex.hasMatch(value!)) {
                    // regex makes sure users only enter number values
                    return 'Please enter a valid number amount';
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
                validator: (value) {
                  // The validator receives the text that the user has entered.

                  //way 2: calling regex created at beginning of file
                  if (!numbersOnlyRegex.hasMatch(value!)) {
                    return 'Please enter a valid number amount';
                  }
                  return null;
                },
              ),

              // text field for item id
              TextFormField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter the item\'s ID',
                ),
                controller: _idController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  //!CANT USE FUTURES IN VALIDAOTR, SO PERHAPS PROVIDE A WARNING MESSAGE?
                  //TODO: create and call a method here that searches through every item in the store and looks for matching id value. if the id val is already in the store, reject using that string as an id again. perhaps pass _idController.text to a method similar to findItemByQR in the database.dart file. see if the id matches anything already in the database. 

                 
                  //way 2: calling regex created at beginning of file
                   if (value == null || value.isEmpty) {
                    return 'Please enter an ID';
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
                              price: double.parse(_priceController.text),
                              quantity: int.parse(_quantityController.text),
                              mostRecentScanIn:
                                  _currentDateTime, // pulls from the  _currentDateTime var created above.
                              id: _idController.text,
                            );

                            setState(() {
                              _isProcessing = false;
                            });

                            Navigator.of(context)
                                .pop(); // return to previous screen after operation is complete
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
