import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:howell_capstone/src/utilities/database.dart';
import 'package:howell_capstone/src/widgets/line-chart-day/line-data-day.dart';
import 'package:intl/intl.dart';

class LineChartWidgetDay extends StatefulWidget {
  final String itemID;

  LineChartWidgetDay({Key? key, required this.itemID}) : super(key: key);

  @override
  State<LineChartWidgetDay> createState() => _LineChartWidgetDayState();
}

class _LineChartWidgetDayState extends State<LineChartWidgetDay>
    with AutomaticKeepAliveClientMixin {
  List<Color> _gradientColors = [];

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
    prepareQuantityData(); // putting it in the init state calls it once on the first build
  }

  void prepareQuantityData() async {
    final List<QuantityOverDay> data = await Database().getDayLineData(
        widget.itemID,
        int.parse(getSelectedMonth()),
        int.parse(getSelectedDay()),
        int.parse(getSelectedYear())); // this gets line data for a specific day

    //print('hit the _prepareQuantity method');

    double minY = double.maxFinite;
    double maxY = double.minPositive;

    // we only want to map to _values if the data list is not empty.
    if (data.isNotEmpty) {
      _values = data.map((entry) {
        if (minY > (entry.quantity)) minY = entry.quantity;
        if (maxY < (entry.quantity)) maxY = entry.quantity;
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

      setState(() {});
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
          bottom: BorderSide(
            color: Colors.transparent,
          ),
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
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      // getTitles: (value) =>                                          // we leave getTitles out if we jsut want it to display the base value with no formatting
      //     NumberFormat.compactCurrency(symbol: '\$').format(value),
      reservedSize: 32,
      margin: 10,
      interval: _leftTitlesInterval / 6 > 0
          ? _leftTitlesInterval
          : 1, // prevents us from getting "sidetitles = 0 error"  ins the event we only have 1 datapoint in the map. changing the denominator (4) will change how many intervals are on the left side
    );
  }

  SideTitles _bottomTitles() {
    return SideTitles(
      showTitles: true,
      getTextStyles: (context, value) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      getTitles: (value) {
        final DateTime date =
            DateTime.fromMillisecondsSinceEpoch(value.toInt());
        return DateFormat.jm().format(
            date); // this changes what the x label shows/  right now this is overcrowding
      },
      reservedSize: 22,
      margin: 10,
      interval: ((_maxX - _minX) / 4) > 0
          ? (_maxX - _minX) / 4
          : 1, // prevents us from getting "sidetitles = 0 error"  ins the event we only have 1 datapoint in the map.  changing the denominator (4) will change how many intervals are on the bottom
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
    // load the current themes colors into the gradient colors list to be used with the graph.
    _gradientColors = [
      Theme.of(context).colorScheme.onBackground,
      Theme.of(context).colorScheme.secondaryVariant,
    ];

    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 37,
                ),
                Text(
                  'Daily Quantity',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 17,
                ),
                monthAndDayBtn(context),
                const SizedBox(
                  height: 17,
                ),
                Expanded(
                  child: Row(
                    children: [
                      RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Quantity',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          )),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 35.0, left: 5.0),
                          child: _values.isNotEmpty
                              ? LineChart(_mainData())
                              : Placeholder(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Time',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
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

//  below is the datetime picker widget, which chooses to the month and day

  String selectedMonth = "0"; // this is the default month
  String selectedDay = "0";
  String selectedYear = "0";

  String firstPageLoad =
      "CHOOSE DAY"; // this is what will show in the datepicker container on the first page load
  bool isDayChosen = false;

  Widget monthAndDayBtn(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            onPressed: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(2000, 1, 1),
                  maxTime: DateTime.now(),
                  onChanged: (date) {}, onConfirm: (date) {
                print('confirm $date');
                setState(() {
                  isDayChosen =
                      true; // now that isDayChosen is true, we will show that date in the datepicker container
                  selectedMonth = date.month.toString();
                  selectedDay = date.day.toString();
                  selectedYear = date.year.toString();
                  _values =
                      []; // reset _values to 0 so that prepareQuantityData() can rebuild it. and, if no _values are present for the month, it will display placeholder
                  prepareQuantityData(); // this forces a rebuild of the graph
                });
              }, currentTime: DateTime.now(), locale: LocaleType.en);
            },
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.secondaryVariant),
                  borderRadius: BorderRadius.all(new Radius.circular(10.0))),
              child: Text(
                isDayChosen
                    ? selectedMonth + " / " + selectedDay + " / " + selectedYear
                    : firstPageLoad,
              ),
            )),
      ],
    );
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
