import 'package:budget_planner_notion/home.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:budget_planner_notion/models/item_model.dart';

class SpendingChart extends StatelessWidget {
  final List<Item> items;

  const SpendingChart({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spending = <String, double>{};

    items.forEach(
      (item) => spending.update(
        item.category,
        (value) => value + item.price,
        ifAbsent: () => item.price,
      ),
    );
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(16),
        height: 360,
        child: Column(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: spending
                      .map(
                        (category, amountSpent) => MapEntry(
                          category,
                          PieChartSectionData(
                            color: getCategoryColor(category),
                            radius: 100.0,
                            title: '\$${amountSpent.toStringAsFixed(2)}',
                            value: amountSpent,
                          ),
                        ),
                      )
                      .values
                      .toList(),
                  sectionsSpace: 0,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: spending.keys
                  .map((category) => _Indicator(
                        color: getCategoryColor(category),
                        text: category,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const _Indicator({Key? key, required this.color, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 16.0,
          width: 16.0,
          color: color,
        ),
        SizedBox(width: 4.0),
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
