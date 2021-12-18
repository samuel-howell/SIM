import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:howell_capstone/src/widgets/line-data.dart';
import 'package:howell_capstone/src/widgets/line-titles.dart';
import 'package:intl/intl.dart';

class LineChartWidget extends StatefulWidget {
  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  final List<Color> _gradientColors = [
    const Color(0xFF6FFF7C),
    const Color(0xFF0087FF),
    const Color(0xFF5620FF),
  ];





//! adapted from https://dev.to/kamilpowalowski/stock-charts-with-flchart-library-1gd2 and  https://github.com/kamilpowalowski/fluttersafari/blob/fl_chart/lib/line_chart.dart

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
   _prepareQuantityData();
  }

  void _prepareQuantityData() async {
      final List<QuantityDaily> data = await Database().getLineData();
      //print('hit the _prepareQuantity method');

      double minY = double.maxFinite;
      double maxY = double.minPositive;

      _values = data.map((entry) {
      if (minY > (entry.quantity)) minY = entry.quantity.toDouble();
      if (maxY < (entry.quantity )) maxY = entry.quantity.toDouble();
              //   print(entry.date.millisecondsSinceEpoch.toDouble().toString());
      return FlSpot(
        entry.date.millisecondsSinceEpoch.toDouble(),
        entry.quantity.toDouble(),
      );
      
    }).toList();



    _minX = _values.first.x;
    _maxX = _values.last.x;
    _minY = (minY / _divider).floorToDouble() * _divider;
    _maxY = (maxY / _divider).ceilToDouble() * _divider;
    _leftTitlesInterval =
        ((_maxY - _minY) / (_leftLabelsCount - 1)).floorToDouble();

    setState(() {});
  }

  
  
  LineChartData _mainData() {
 

      return LineChartData(
        gridData: _gridData(),
        titlesData: FlTitlesData(
          bottomTitles: _bottomTitles(),
          leftTitles: _leftTitles(),
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
        color: Colors.white54,
        fontSize: 14,
      ),
      getTitles: (value) =>
          NumberFormat.compactCurrency(symbol: '\$').format(value),
      reservedSize: 28,
      margin: 12,
      interval: _leftTitlesInterval,
    );
  }

  SideTitles _bottomTitles() {
    return SideTitles(
      showTitles: true,
      getTextStyles: (context, value) => TextStyle(
        color: Colors.white54,
        fontSize: 14,
      ),
      getTitles: (value) {
        final DateTime date =
            DateTime.fromMillisecondsSinceEpoch(value.toInt());
        return DateFormat.MMM().format(date);
      },
      margin: 8,
      interval: (_maxX - _minX) / 6,
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
        child: _values.isEmpty ? Placeholder() : LineChart(_mainData()),
      ),
    );
  }
}














//! ////////////////////////////////////////////////////////////////////////////////////
  // @override
  // Widget build(BuildContext context) {

  //   return LineChart(
  //     LineChartData(
  //       minX: 0,
  //       maxX: 11,
  //       minY: 0,
  //       maxY: 6,
  //       titlesData: LineTitles.getTitleData(),
  //       gridData: FlGridData(
  //         verticalInterval: 1,
  //         horizontalInterval: 1,
  //         show: true,
  //         getDrawingHorizontalLine: (value) {
  //           return FlLine(
  //               color: const Color(0xff23cfe6),
  //               strokeWidth: 1, // thickness of horizontal lines
  //           );
  //         },
  //         drawVerticalLine: true,
  //         getDrawingVerticalLine: (value) {
  //           return FlLine(
  //               color: const Color(0xff23cfe6),
  //               strokeWidth: 1, // thickness of vertical lines
  //           );
  //         },
    
  //       ),
  //       borderData: FlBorderData(
  //         show: true,
  //         border: Border.all(color: const Color(0xff23cfe6), width: 2),
  //       ),
  //       lineBarsData: [
  //         LineChartBarData(
  //           spots:[
  //              FlSpot(0, 3),
  //               FlSpot(2.6, 2),
  //               FlSpot(4.9, 5),
  //               FlSpot(6.8, 2.5),
  //               FlSpot(8, 4),
  //               FlSpot(9.5, 3),
  //               FlSpot(11, 4),
  //         ],
  //         isCurved: true,
  //         colors: _gradientColors,
  //         barWidth: 5,
  //         belowBarData: BarAreaData(
  //           show: true,
  //           colors: _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
  //         )
  //         )
  //       ]
  //     ),
  //     swapAnimationDuration: Duration(milliseconds: 150), // Optional
  //     swapAnimationCurve: Curves.linear,
  //   );
  // }
  //}

