import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:intl/intl.dart';

class CsvToList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return CsvToListState();
  }

}

  DateTime now = DateTime.now();
  String formattedDate = DateFormat('MM/dd/yyyy - HH:mm').format(now);
  List<List<dynamic>> itemData = [];


class CsvToListState extends State<CsvToList>{

 // format the date like "11/15/2021 - 16:52"

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<PlatformFile>? _paths;
  String? _extension="csv";
  FileType _pickingType = FileType.custom;


  @override
  void initState() {
    super.initState();
    itemData  = List<List<dynamic>>.empty(growable: true);
  }
  @override
  Widget build(BuildContext context) {


      return Scaffold(
         key: _scaffoldKey,
        appBar: AppBar(title:Text("CSV To List")),
        
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.green,
                  height: 30,
                  child: TextButton(
                    child: Text("CSV ITEM LIST IMPORT",style: TextStyle(color: Colors.white),), //TODO: Create a similar button and process that imports stores and their addresses, then one that imports quantity data just so I can build a detailed quantity graph quickly
                    onPressed: _openFileExplorer,
                  ),
                ),
              ),
              
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: itemData.length,
                  itemBuilder: (context,index){
              
                    try{
                    // the index number is based on which column the data is in in an excel file, starting from cell 0,0
                    Database.addItem(
                      name: itemData[index][1],
                      price: double.parse(itemData[index][2].toString()),   
                      quantity: itemData[index][3], 
                      description: itemData[index][4], 
                      mostRecentScanIn: formattedDate, 
                      id: itemData[index][0].toString());
                    }
                    catch(exception){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("ERROR importing row containing [" + itemData[index][0] + ", " + itemData[index][1] + ", " + itemData[index][2] + ", " + itemData[index][3] + ", " + itemData[index][4] +  "]. Please make sure row conforms to CSV import guidelines."),
                            ],
                          ),
                        )),
                      );
                    }
                  
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(itemData[index][1] + ' was imported successfully!'),
                          ],
                        ),
                      )),
                    );
                  }
                  ),
            ],
          ),
        ),
      );
  }






  openFile(filepath) async
  {
    File f = new File(filepath);
    print("CSV to List");
    final input = f.openRead();
    final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
    print(fields);
    setState(() {
      itemData=fields;
    });
  }

  void _openFileExplorer() async {

    try {

      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
      Fluttertoast.showToast(msg: "Unsupported operation: " + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      openFile(_paths![0].path);
      print(_paths);
      print("File path ${_paths![0]}");
      print(_paths!.first.extension);

    });
  }
}