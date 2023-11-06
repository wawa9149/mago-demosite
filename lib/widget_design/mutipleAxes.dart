import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesData {
  SalesData(this.year, this.sales);
  final double year;
  final double sales;
}

class MultipleAxesChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      height: 300,
      child: SfCartesianChart(
        title: ChartTitle(text: 'Spline Area Chart'),
        legend: Legend(isVisible: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries>[
          SplineAreaSeries<SalesData, double>(
            dataSource: <SalesData>[
              SalesData(2005, 21),
              SalesData(2006, 24),
              SalesData(2007, 36),
              SalesData(2008, 38),
              SalesData(2009, 54),
              SalesData(2010, 57),
              SalesData(2011, 70)
            ],
            xValueMapper: (SalesData sales, _) => sales.year,
            yValueMapper: (SalesData sales, _) => sales.sales,
            opacity: 0.5, // 영역의 투명도 설정
          ),
          SplineAreaSeries<SalesData, double>(
            dataSource: <SalesData>[
              SalesData(2005, 53),
              SalesData(2006, 88),
              SalesData(2007, 12),
              SalesData(2008, 54),
              SalesData(2009, 65),
              SalesData(2010, 78),
              SalesData(2011, 23)
            ],
            xValueMapper: (SalesData sales, _) => sales.year,
            yValueMapper: (SalesData sales, _) => sales.sales,
            opacity: 0.5, // 영역의 투명도 설정
          ),

        ],
        primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
        primaryYAxis: NumericAxis(
            minimum: 0, maximum: 100, interval: 20, labelFormat: '{value}%'),
      ),
    );
  }
}
