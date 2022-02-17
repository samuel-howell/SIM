import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;


class StoreCsvImport extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return StoreCsvImportState();
  }

}

  DateTime now = DateTime.now();
  String formattedDate = DateFormat('MM/dd/yyyy - HH:mm').format(now);
  List<List<dynamic>> itemData = [];

int importSelected = 0; // depending on what this number is is what database operation is performed

class StoreCsvImportState extends State<StoreCsvImport>{

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
        appBar: AppBar(),
        
        body: SingleChildScrollView(
          child: Column(
            children: [
           
               Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                 // color: Theme.of(context).primaryColor,
                 // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  height: 50,
                  child: TextButton(
                    child: Text("Import CSV Store List",), //TODO: Create  one that imports quantity data just so I can build a detailed quantity graph quickly
                    onPressed: () => [
                      _openFileExplorer()
                    ]
                  ),
                ),
              ),
              
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: itemData.length,
                  itemBuilder: (context,index){
              

                  // for store import csv
                 
                      try{
                      // the index number is based on which column the data is in in an excel file, starting from cell 0,0
                      Database.addStore(
                        name: itemData[index][0],
                        address: itemData[index][1]);
                      }
                      catch(exception){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red), 
                              borderRadius: BorderRadius.circular(10),

                            ),
                            child: Card(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ERROR importing row containing [" + itemData[index][0] + ", " + itemData[index][1] +   "]. Please make sure row conforms to CSV import guidelines."),
                                ],
                              ),
                            )),
                          ),
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
                              Text(itemData[index][0] + ' at address ' + itemData[index][1] + ' was imported successfully!'),
                            ],
                          ),
                        )),
                      );
                   // end if(importedSelected == 2)

                  } 
                  ),
            ],
          ),
        ),
      );
  }



Uint8List uploadedCsv = new Uint8List(0);
String option1Text = "";


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

    if (kIsWeb)
    {
      print('registering as web file picker');
        startWebFilePicker();
    }
    else{ // for android and ios
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

  setImportSelected(int number) {
    importSelected = number;
  }

  // since we can't use .path with file picker pkg on Web, we have to use the workaround below
  startWebFilePicker() async {

    /* we have to get the bytes of the file since we can't use the file path. once we get the bytes, we convert to base64 (thus putting the csv in UInt8List)
        then we can convert that back to something that StoreCsvImportConverter can use  using utf8.decode */

      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
        uploadInput.click();

          uploadInput.onChange.listen((e) {
            // read file content as dataURL
            final files = uploadInput.files;
            if (files!.length == 1) {
              final file = files[0];
              html.FileReader reader = html.FileReader();

              reader.onLoadEnd.listen((e) {
                setState(() async {
                  uploadedCsv = Base64Decoder()
                      .convert(reader.result.toString().split(",").last);

                  final fields = CsvToListConverter().convert(utf8.decode(uploadedCsv));
                    print(fields);
                    setState(() {
                      itemData=fields;
                    });

                  print('uploadedCSV is now ' + utf8.decode(uploadedCsv)); // utf8.decode returns the UInt8List to readable csv
                });
              });

              reader.onError.listen((fileEvent) {
                setState(() {
                  option1Text = "Some Error occured while reading the file";
                });
              });

              reader.readAsDataUrl(file);

            }
          });

      }
}

