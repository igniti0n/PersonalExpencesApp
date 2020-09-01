import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTransaction,
  }) :  super(key: key);

  final Transaction transaction;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          elevation: 8,
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: Padding(
                  padding: EdgeInsets.all(4),
                  child: FittedBox(
                      child: Text(
                          '\$${transaction.amount.toStringAsFixed(2)}'))),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 560
            ? FlatButton.icon(
                icon: Icon(Icons.delete),
                label: Text("Delete transaction"),
                textColor: Colors.red,
                onPressed: () {
                  deleteTransaction(transaction.id);
                },
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  deleteTransaction(transaction.id);
                },
              ),
      ),
    );
  }
}