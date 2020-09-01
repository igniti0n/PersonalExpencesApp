import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function _addNewTransaction;
  final Function _saveTransaction;

  NewTransaction(this._addNewTransaction, this._saveTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleControler = new TextEditingController();
  final _amountControler = new TextEditingController();
  DateTime _selectedDate;

  void addTransaction() {
    if (_titleControler.text.isEmpty ||
        _amountControler.text.isEmpty ||
        double.parse(_amountControler.text) < 0 ||
        _selectedDate == null) return;

    widget._addNewTransaction(_titleControler.text,
        double.parse(_amountControler.text), _selectedDate);
    //widget._saveTransaction();
    Navigator.of(context).pop();
  }

  void _showCalendar() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int keyboardPadding = 10;

    return Card(
      elevation: 2,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.purpleAccent),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + keyboardPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                style: Theme.of(context).textTheme.title,
                decoration: InputDecoration(labelText: "Title"),
                controller: _titleControler,
                onSubmitted: (_) => addTransaction(),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                controller: _amountControler,
                keyboardType: TextInputType.number,
                onSubmitted: (_) =>
                    addTransaction(), //ovjde ne predajmo pokazivac vec pozivamo funkciju
              ),
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? "No date choosen"
                          : "Selected date: ${DateFormat.yMd().format(_selectedDate)}"),
                    ),
                    FlatButton(
                      child: Text(
                        "Choose Date",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: _showCalendar,
                    ),
                  ],
                ),
              ),
              RaisedButton(
                child: Text(
                  "Add Transaction",
                ),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: () {
                 
                  addTransaction();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
