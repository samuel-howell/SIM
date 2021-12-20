import 'package:flutter/material.dart';
import 'package:howell_capstone/src/utilities/database.dart';

class GraphYMDDropdownItem extends StatefulWidget {

  const GraphYMDDropdownItem({ Key? key }) : super(key: key);


  // this is how we pass methods from 1 stateful widget (GraphYMDDropdownItem in this case) to another (LineChartWidget in this case)
  getSelectedMonth() => createState().getSelectedMonth();

  @override
  _GraphYMDDropdownItemState createState() => _GraphYMDDropdownItemState();
}

class _GraphYMDDropdownItemState extends State<GraphYMDDropdownItem> {

  String selectedMonth = "12"; // this is the default month
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selectedMonth,
      style: TextStyle(color: Color(0xFF5620FF),fontSize: 30),
      onChanged: (String? month){
        setState(() {
          selectedMonth = month!;
          
        });
      },
      items: dropdownItems
      );
}



List<DropdownMenuItem<String>> get dropdownItems{
  List<DropdownMenuItem<String>> menuItems = [
    // DropdownMenuItem(child: Text("Day"),value: "day"),
    // DropdownMenuItem(child: Text("Month"),value: "month"),
    // DropdownMenuItem(child: Text("Year"),value: "year"),

    DropdownMenuItem(child: Text("January"),value: "1"),
    DropdownMenuItem(child: Text("February"),value: "2"),
    DropdownMenuItem(child: Text("March"),value: "3"),
    DropdownMenuItem(child: Text("April"),value: "4"),
    DropdownMenuItem(child: Text("May"),value: "5"),
    DropdownMenuItem(child: Text("June"),value: "6"),
    DropdownMenuItem(child: Text("July"),value: "7"),
    DropdownMenuItem(child: Text("August"),value: "8"),
    DropdownMenuItem(child: Text("September"),value: "9"),
    DropdownMenuItem(child: Text("October"),value: "10"),
    DropdownMenuItem(child: Text("November"),value: "11"),
    DropdownMenuItem(child: Text("December"),value: "12"),
  ];
  return menuItems;
}

String getSelectedMonth() {
  return selectedMonth;
}

}

