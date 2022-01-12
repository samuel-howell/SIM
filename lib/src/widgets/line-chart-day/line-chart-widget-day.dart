import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:howell_capstone/src/widgets/line-chart-day/line-data-day.dart';
import 'package:intl/intl.dart';

class LineChartWidgetDay extends StatefulWidget {

  final String itemID;

  LineChartWidgetDay({Key? key, required this.itemID}) : super(key: key);


  @override
  State<LineChartWidgetDay> createState() => _LineChartWidgetDayState();
}

class _LineChartWidgetDayState extends State<LineChartWidgetDay> with AutomaticKeepAliveClientMixin {
  final List<Color> _gradientColors = [
    const Color(0xFF6FFF7C),
    const Color(0xFF0087FF),
    const Color(0xFF5620FF),
  ];


  //  the AutomaticKeepAliveClientMixin coupled with this override keeps that graph from refreshing everytime the tab is swiped to on the item info page.
  @override
  bool get wantKeepAlive => true;



  final int _divider = 25;
  final int _leftLabelsCount = 4;
  
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
          
      final List<QuantityOverDay> data = await Database().getDayLineData(widget.itemID, int.parse(getSelectedMonth()), int.parse(getSelectedDay()), int.parse(getSelectedYear())); // this gets line data for a specific day

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
              print("LEFT TITLES INTERVAL IS " + _leftTitlesInterval.toString());

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
          border: const Border( 
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
          ),
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
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(
        show: false,
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
        color:  Color(0xff72719b),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      // getTitles: (value) =>                                          // we leave getTitles out if we jsut want it to display the base value with no formatting
      //     NumberFormat.compactCurrency(symbol: '\$').format(value),
      reservedSize: 32,
      margin: 10,
      interval: _leftTitlesInterval /6 > 0 ? _leftTitlesInterval : 1, // prevents us from getting "sidetitles = 0 error"  ins the event we only have 1 datapoint in the map. changing the denominator (4) will change how many intervals are on the left side
    );
  }

  SideTitles _bottomTitles() {
    return SideTitles(
      showTitles: true,
      getTextStyles: (context, value) => TextStyle(
        color:  Color(0xff72719b),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      getTitles: (value) {
        final DateTime date =
            DateTime.fromMillisecondsSinceEpoch(value.toInt());
        return DateFormat.jm().format(date); // this changes what the x label shows/  right now this is overcrowding
      },
      reservedSize: 22,
      margin: 10,
      interval: ((_maxX - _minX) / 4) > 0 ? (_maxX - _minX) / 4 : 1, // prevents us from getting "sidetitles = 0 error"  ins the event we only have 1 datapoint in the map.  changing the denominator (4) will change how many intervals are on the bottom
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
      aspectRatio: 1.23,
      child: Container(

        decoration: const BoxDecoration(
           
          gradient: LinearGradient(
            colors: [
              Color(0xff2c274c),
              Color(0xff46426c),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        

          child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 37,
                ),
                const Text(
                  'Daily Quantity',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(
                  height: 17,
                ),

                 monthAndDayDropdownBtn(context),
            
                const SizedBox(
                  height: 17,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 35.0, left: 5.0),
                    child: _values.isNotEmpty ? LineChart(_mainData()) : Placeholder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
                ),



      ),
    );
  }





//  below is the dropdown buttone widget, which chooses to the month and day

 String selectedMonth = "0"; // this is the default month
 String selectedDay = "0";
 String selectedYear = "0";


//TODO: convert this to a datetime picker widget from pub.dev so you can include the year too
Widget monthAndDayDropdownBtn (BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DropdownButton(
          value: selectedMonth,
          style: TextStyle(color: Color(0xff72719b),fontSize: 25),
          onChanged: (String? month){
            setState(() {
              selectedMonth = month!;
              _values = []; // reset _values to 0 so that prepareQuantityData() can rebuild it. and, if no _values are present for the month, it will display placeholder
              prepareQuantityData(); // this forces a rebuild of the graph
            });
          },
          items: monthDropdownItems
          ),

          DropdownButton(
          value: selectedDay,
          style: TextStyle(color: Color(0xff72719b),fontSize: 25),
          onChanged: (String? day){
            setState(() {
              selectedDay = day!;
              _values = []; // reset _values to 0 so that prepareQuantityData() can rebuild it. and, if no _values are present for the month, it will display placeholder
              prepareQuantityData(); // this forces a rebuild of the graph
            });
          },
          items: dayDropdownItems
          ),
               ],
    );

       
 
}



List<DropdownMenuItem<String>> get monthDropdownItems{
  List<DropdownMenuItem<String>> monthMenuItems = [
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
  return monthMenuItems;
}


List<DropdownMenuItem<String>> get dayDropdownItems{
  List<DropdownMenuItem<String>> dayMenuItems = [
    DropdownMenuItem(child: Text("Select Day"),value: "0"), // we have to give a default val that will never actually be a month for the selectedMonth to initialize to.
    DropdownMenuItem(child: Text("1"),value: "1"),
    DropdownMenuItem(child: Text("2"),value: "2"),
    DropdownMenuItem(child: Text("3"),value: "3"),
    DropdownMenuItem(child: Text("4"),value: "4"),
    DropdownMenuItem(child: Text("5"),value: "5"),
    DropdownMenuItem(child: Text("6"),value: "6"),
    DropdownMenuItem(child: Text("7"),value: "7"),
    DropdownMenuItem(child: Text("8"),value: "8"),
    DropdownMenuItem(child: Text("9"),value: "9"),
    DropdownMenuItem(child: Text("10"),value: "10"),
    DropdownMenuItem(child: Text("11"),value: "11"),
    DropdownMenuItem(child: Text("12"),value: "12"),
    DropdownMenuItem(child: Text("13"),value: "13"),
    DropdownMenuItem(child: Text("14"),value: "14"),
    DropdownMenuItem(child: Text("15"),value: "15"),
    DropdownMenuItem(child: Text("16"),value: "16"),
    DropdownMenuItem(child: Text("17"),value: "17"),
    DropdownMenuItem(child: Text("18"),value: "18"),
    DropdownMenuItem(child: Text("19"),value: "19"),
    DropdownMenuItem(child: Text("20"),value: "20"),
    DropdownMenuItem(child: Text("21"),value: "21"),
    DropdownMenuItem(child: Text("22"),value: "22"),
    DropdownMenuItem(child: Text("23"),value: "23"),
    DropdownMenuItem(child: Text("24"),value: "24"),
    DropdownMenuItem(child: Text("25"),value: "25"),
    DropdownMenuItem(child: Text("26"),value: "26"),
    DropdownMenuItem(child: Text("27"),value: "27"),
    DropdownMenuItem(child: Text("28"),value: "28"),
    DropdownMenuItem(child: Text("29"),value: "29"),
    DropdownMenuItem(child: Text("30"),value: "30"),
    DropdownMenuItem(child: Text("31"),value: "31"),
  ];
  return dayMenuItems;
}

String getSelectedMonth() {
 print('the selected month is ' + selectedMonth);
  return selectedMonth;
}

String getSelectedDay() {
 print('the selected day is ' + selectedDay);
  return selectedDay;
}

String getSelectedYear() {
  print('the selected year is ' + selectedYear);
  return selectedYear;
}

}






