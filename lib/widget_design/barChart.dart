import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ColumnRounded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: 'Sales Data'),
        primaryXAxis: CategoryAxis(
          title: AxisTitle(text: 'Month'),
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(text: 'Revenue (in millions)'),
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0),
          majorGridLines: MajorGridLines(width: 1),
        ),
        series: <ChartSeries>[
          ColumnSeries<SalesData, String>(
            dataSource: <SalesData>[
              SalesData('Jan', 30),
              SalesData('Feb', 40),
              SalesData('Mar', 28),
              SalesData('Apr', 42),
              SalesData('May', 25),
            ],
            borderRadius: BorderRadius.circular(10),
            // Apply rounded corners here
            xValueMapper: (SalesData sales, _) => sales.month,
            yValueMapper: (SalesData sales, _) => sales.sales,
          ),
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.month, this.sales);
  final String month;
  final double sales;
}
