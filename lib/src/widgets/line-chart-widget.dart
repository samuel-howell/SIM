import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:howell_capstone/src/widgets/line-data.dart';
import 'package:howell_capstone/src/widgets/line-titles.dart';
import 'package:intl/intl.dart';

class LineChartWidget extends StatefulWidget {

  final String itemID;

  LineChartWidget({Key? key, required this.itemID}) : super(key: key);


  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> with AutomaticKeepAliveClientMixin {
  final List<Color> _gradientColors = [
    const Color(0xFF6FFF7C),
    const Color(0xFF0087FF),
    const Color(0xFF5620FF),
  ];


  //  the AutomaticKeepAliveClientMixin coupled with this override keeps that graph from refreshing everytime the tab is swiped to on the item info page.
  @override
  bool get wantKeepAlive => true;



  final int _divider = 25;
  final int _leftLabelsCount = 6;
  
  List<FlSpot> _values = [];

  double _minX = 0;
  double _maxX = 0;
  double _minY = 0;
  double _maxY = 0;
  double _leftTitlesInterval = 0;

  @override
  void initState() {
    super.initState();
   prepareQuantityData();  // putting it in the init state calls it once on the first build 
  }

  void prepareQuantityData() async {
      //final List<QuantityDaily> data = await Database().getLineData(widget.itemID);    // this gets line data based on all data points
          
      final List<QuantityDaily> data = await Database().getMonthLineData(widget.itemID, int.parse(getSelectedMonth())); // this gets line data for a specific month

      //print('hit the _prepareQuantity method');

      double minY = double.maxFinite;
      double maxY = double.minPositive;

      // we only want to map to _values if the data list is not empty.
      if(data.isNotEmpty){

            _values = data.map((entry) {
            if (minY > (entry.quantity)) minY = entry.quantity;
            if (maxY < (entry.quantity )) maxY = entry.quantity;
                      //  print(entry.date.millisecondsSinceEpoch.toDouble().toString());
                      //  print(entry.quantity.toString());
                      //  print('miny is ' + minY.toString());
                      //  print('maxy is ' + maxY.toString());
                      print('graph built');

            return FlSpot(
              entry.date.millisecondsSinceEpoch.toDouble(),
              entry.quantity,
            );
            
          }).toList();
            


          _minX = _values.first.x;
          _maxX = _values.last.x;
          _minY = (minY / _divider).floorToDouble() * _divider;
          _maxY = (maxY / _divider).ceilToDouble() * _divider;
          _leftTitlesInterval =
              ((_maxY - _minY) / (_leftLabelsCount - 1)).floorToDouble();

          setState(() {
          });
      }
  }

  
  LineChartData _mainData() {
 

      return LineChartData(
        gridData: _gridData(),
        titlesData: FlTitlesData(
          bottomTitles: _bottomTitles(),
          leftTitles: _leftTitles(),
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
        ),
        borderData: FlBorderData(
          border: Border.all(color: Colors.white12, width: 1),
        ),
        minX: _minX,
        maxX: _maxX,
        minY: _minY,
        maxY: _maxY,
        lineBarsData: [_lineBarData()],
      );
    }

  LineChartBarData _lineBarData() {
    return LineChartBarData(
      spots: _values,
      colors: _gradientColors,
      colorStops: const [0.25, 0.5, 0.75],
      gradientFrom: const Offset(0.5, 0),
      gradientTo: const Offset(0.5, 1),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        colors: _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        gradientColorStops: const [0.25, 0.5, 0.75],
        gradientFrom: const Offset(0.5, 0),
        gradientTo: const Offset(0.5, 1),
      ),
    );
  }

  SideTitles _leftTitles() {
    return SideTitles(
      showTitles: true,
      getTextStyles: (context, value) => TextStyle(
        color:  Color(0xFF5620FF),
        fontSize: 14,
      ),
      // getTitles: (value) =>                                          // we leave getTitles out if we jsut want it to display the base value with no formatting
      //     NumberFormat.compactCurrency(symbol: '\$').format(value),
      reservedSize: 28,
      margin: 12,
      interval: _leftTitlesInterval > 0 ? _leftTitlesInterval : 1, // prevents us from getting "sidetitles = 0 error"  ins the event we only have 1 datapoint in the map
    );
  }

  SideTitles _bottomTitles() {
    return SideTitles(
      showTitles: true,
      getTextStyles: (context, value) => TextStyle(
        color:  Color(0xFF5620FF),
        fontSize: 14,
      ),
      getTitles: (value) {
        final DateTime date =
            DateTime.fromMillisecondsSinceEpoch(value.toInt());
        return DateFormat.MMM().format(date);
      },
      margin: 8,
      interval: ((_maxX - _minX) / 6) > 0 ? (_maxX - _minX) / 6 : 1, // prevents us from getting "sidetitles = 0 error"  ins the event we only have 1 datapoint in the map
    );
    
  }

  FlGridData _gridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.white12,
          strokeWidth: 1,
        );
      },
      checkToShowHorizontalLine: (value) {
        return (value - _minY) % _leftTitlesInterval == 0;
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return AspectRatio(

      aspectRatio: 1.70,
      child: Padding(
        padding:
            const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
        child: getWidgets()


      ),
    );
  }

//getWidget is basically just an extended if else for  the child property 
  Widget getWidgets() {
       if(_values.isEmpty){
         print(' ');
         print('VALUES IS EMPTY');
         print(' ');
          return Scaffold(
          body: 
          Align(
            alignment: Alignment.topLeft,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints){
          return SingleChildScrollView(
            child: Column( children: [
              monthDropdownBtn(context),
              Container(
                height: constraints.maxHeight/1.1,
                width: constraints.maxWidth,
                
                child: Placeholder()) //TODO: change this placeholder to a custom graphic
            
                    ]
                  ),
                );
              }
            )
              
            )
          ) ;
        }
        else{
          print(' ');
         print('VALUES IS NOT EMPTY');
         print(_values.toString());
         print(' ');
          return Scaffold(
          body: 
          Align(
            alignment: Alignment.topLeft,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints){
          return SingleChildScrollView(
            child: Column( children: [
              //GraphYMDDropdownItem(),
              monthDropdownBtn(context),
              Container(
                height: constraints.maxHeight/1.1,
                width: constraints.maxWidth,
                // child: LineChart(_mainData())
                child: LineChart(
                  _mainData(),
                  swapAnimationDuration: Duration(milliseconds: 150), //TODO: make these animations actually work
                  )
                      )
                    ]
                  ),
                );
              }
            )
              
            )
          ) ;
        }
}



//  below is the dropdown buttone widget, which chooses to the month

 String selectedMonth = "0"; // this is the default month
  
Widget monthDropdownBtn (BuildContext context) {
    return DropdownButton(
      value: selectedMonth,
      style: TextStyle(color: Color(0xFF5620FF),fontSize: 30),
      onChanged: (String? month){
        setState(() {
          selectedMonth = month!;
          _values = []; // reset _values to 0 so that prepareQuantityData() can rebuild it. and, if no _values are present for the month, it will display placeholder
          // if(_values.isNotEmpty)
          // {
            
          // }
          prepareQuantityData(); // this forces a rebuild of the graph
        });
      },
      items: dropdownItems
      );
}



List<DropdownMenuItem<String>> get dropdownItems{
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text("Select Month"),value: "0"), // we have to give a default val that will never actually be a month for the selectedMonth to initialize to.
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
 print('the selected month is ' + selectedMonth);
  return selectedMonth;
}

}





