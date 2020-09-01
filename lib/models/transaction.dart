import 'dart:convert';

import 'package:flutter/foundation.dart';

String toJson(Transaction tr) => jsonEncode(tr.toJson());

Transaction fromJson(Map<String,dynamic> map) => Transaction.fromJson(map);

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Transaction(
      {@required this.amount,
      @required this.date,
      @required this.id,
      @required this.title});


   factory Transaction.fromJson(Map<String, dynamic> map) => Transaction(
     amount: map['amount'],
     date: DateTime.parse(map['date']),
     title: map['title'],
     id: map['id']
  );

  Map<String,dynamic> toJson() => {
    'amount' : amount,
    'title' :title,
    'id' : id,
    'date' : date.toIso8601String()
  };

}
