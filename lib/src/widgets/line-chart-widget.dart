import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:howell_capstone/src/widgets/line-titles.dart';

class LineChartWidget extends StatelessWidget {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 6,
        titlesData: LineTitles.getTitleData(),
        gridData: FlGridData(
          verticalInterval: 1,
          horizontalInterval: 1,
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
                color: const Color(0xff23cfe6),
                strokeWidth: 1, // thickness of horizontal lines
            );
          },
          drawVerticalLine: true,
          getDrawingVerticalLine: (value) {
            return FlLine(
                color: const Color(0xff23cfe6),
                strokeWidth: 1, // thickness of vertical lines
            );
          },
    
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff23cfe6), width: 2),
        ),
        lineBarsData: [
          LineChartBarData(
            spots:[
               FlSpot(0, 3),
                FlSpot(2.6, 2),
                FlSpot(4.9, 5),
                FlSpot(6.8, 2.5),
                FlSpot(8, 4),
                FlSpot(9.5, 3),
                FlSpot(11, 4),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          )
          )
        ]
      ),
      swapAnimationDuration: Duration(milliseconds: 150), // Optional
      swapAnimationCurve: Curves.linear,
    );
  }
}

