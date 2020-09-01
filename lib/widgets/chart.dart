import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> _recentTransactions;

  Chart(this._recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0;

      for (int i = 0; i < _recentTransactions.length; i++) {
        if (_recentTransactions[i].date.day == weekDay.day &&
            _recentTransactions[i].date.month == weekDay.month &&
            _recentTransactions[i].date.year == weekDay.year)
          totalSum += _recentTransactions[i].amount;
      }

      //print(totalSum);
     // print(DateFormat.E().format(weekDay));

      return {'day': DateFormat.E().format(weekDay).substring(0,1), 'amount': totalSum};
    }).reversed.toList();
  }

  double get maxSum {
    return groupedTransactionValues.fold(0.0, (sum, element) {
      return sum + element['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
  //  print(groupedTransactionValues);
    return Card(
  
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          
            children: groupedTransactionValues.map((element) {
              return Flexible(
                  fit: FlexFit.tight,
                            child: ChartBar(
                  element['day'],
                  element['amount'],
                  maxSum == 0 ? 0.0 : (element['amount'] as double)/maxSum
                ),
              );
            }).toList(),
          
        ),
      ),
    );
  }
}
