import 'package:budget_planner_notion/budget_repo.dart';
import 'package:budget_planner_notion/models/failure_model.dart';
import 'package:budget_planner_notion/spending_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/item_model.dart';
import 'package:budget_planner_notion/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Item>> _futureItems;

  @override
  void initState() {
    super.initState();
    _futureItems = BudgetRepository().getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Budget Tracker',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _futureItems = BudgetRepository().getItems();
          setState(() {});
        },
        child: FutureBuilder<List<Item>>(
          future: _futureItems,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //show pie
              final items = snapshot.data!;
              return ListView.builder(
                itemCount: items.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) return SpendingChart(items: items);

                  final item = items[index - 1];
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          width: 2.0, color: getCategoryColor(item.category)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(
                          '${item.category} | ${DateFormat.yMd().format(item.date)}'),
                      trailing: Text('- ${item.price.toStringAsFixed(2)} Php'),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              final failure = snapshot.error as Failure;
              return Center(child: Text(failure.message));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

Color getCategoryColor(String category) {
  switch (category) {
    case 'Entertainment':
      return Colors.green[400]!;
    case 'Food':
      return Colors.blue[300]!;
    case 'Personal':
      return Colors.red[300]!;
    case 'Transportation':
      return Colors.yellow[300]!;
    case 'Friends':
      return Colors.orange[300]!;
    default:
      return Colors.purple;
  }
}
