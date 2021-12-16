import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineTitles {
  static getTitleData() => FlTitlesData(
    show:true,
    bottomTitles: SideTitles( // for x axis
    interval: 1, // keeps the labels from repeating.  without this, MAR would appear for 2.0 and 2.5, because we switch value.toInt()
      showTitles: true,
      reservedSize: 22,  // bottom space
      getTextStyles: (context, value) => const TextStyle(
        color: Color(0xff68737d),
        fontWeight: FontWeight.bold, 
        fontSize:16,
      ),
      getTitles: (value) {
        switch (value.toInt()) {
          case 2:
            return 'MAR';
          case 5:
            return 'JUN';
          case 8:
            return 'SEP';
        }
        return '';
      },
      margin: 22,
    ),
    leftTitles: SideTitles( // for y axis
      interval: 1,
      showTitles: true,
      getTextStyles: (context, value) => const TextStyle(
        color: Color(0xff68737d),
        fontWeight: FontWeight.bold, 
        fontSize:16,
      ),
      getTitles: (value) {
        switch (value.toInt()) {
          case 2:
            return '20k';
          case 5:
            return '50k';
          case 8:
            return '80k';
        }
        return '';
      },
      reservedSize: 30, // gives us more space around the label
      margin: 22, // space between the label and the grid'
      
    ),
    rightTitles: SideTitles(showTitles: false),
    topTitles: SideTitles(showTitles: false),
  );
}