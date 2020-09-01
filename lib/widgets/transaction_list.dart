import 'package:flutter/material.dart';

import 'transactionItem.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;
  final  Function deleteTransaction;

  TransactionList(this._transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return _transactions.isEmpty
        ? LayoutBuilder(builder: (cntx, constraints) {
            return Column(
              children: <Widget>[
                Text("There are no transactions."),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      "assets/images/waiting.png",
                      fit: BoxFit.cover,
                    )),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return TransactionItem(transaction: _transactions[index], deleteTransaction: deleteTransaction);
            },
            itemCount: _transactions.length,
          );
  }
}


