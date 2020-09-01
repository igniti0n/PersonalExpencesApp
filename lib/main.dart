import 'package:flutter/material.dart';
import 'dart:convert';
//import 'package:flutter/services.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './providers/database.dart';
import './models/http_exception.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp, DeviceOrientation.portraitUp]).then((_) {
  runApp(new MyApp());
  //});
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal expences app',
      theme: ThemeData(
        errorColor: Colors.red,
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold),
              button: TextStyle(color: Colors.white),
            ),
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State {
  List<Transaction> _transactions = [
    // Transaction(
    //     title: "My Transaction", amount: 44.44, date: DateTime.now(), id: "t1"),
    // Transaction(
    //     title: "New House", amount: 88.88, date: DateTime.now(), id: "t2"),
  ];
  bool loaded = false;
  bool _showChart = false;

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime choosenDate) {
    Transaction newTx = new Transaction(
      title: txTitle,
      amount: txAmount,
      id: DateTime.now().toString(),
      date: choosenDate,
    );
    DBProvider.db.insertTransaction(newTx.toJson());
    setState(() {
      _transactions.add(newTx);
    });
  }

  Future<void> _saveTransactions() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (_transactions.length == 0) return;
      print(_transactions.length);

      var data = json.encode({
        'list': _transactions
            .map((tran) => {
                  'title': tran.title,
                  'amount': tran.amount,
                  'id': tran.id,
                  'date': tran.date.toIso8601String(),
                })
            .toList()
      });
      await prefs.setString('data', data);
      print(jsonDecode(prefs.getString('data')));
      //prefs.clear();
    } catch (error) {
      print(error.toString());
    }
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction, _saveTransactions),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  Future<void> deleteTransaction(String id) async {
    // var prefs = await SharedPreferences.getInstance();
    // if (!prefs.containsKey('data') || prefs == null) {
    //   showDialog(
    //       context: context,
    //       child: Dialog(
    //         child: Text('ERROR WHILE DELETING TRANSACTION'),
    //       ));
    //   return;
    //
    try {
      final int res = await DBProvider.db.deleteTransactionDB(id);

      setState(() {
        _transactions.removeWhere((tx) {
          if (tx.id == id) return true;
          return false;
        });
        _saveTransactions();
      });
    } catch (error) {
      throw HttpException("Error while deleting transaction.");
    }
  }

  List<Transaction> get _recentTransactions {
    return _transactions.where(
      (tx) {
        return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
      },
    ).toList();
  }

  Future<void> _loadTransactions() async {
    print("STARTING LOAD");
    if (loaded) {
      print("ALLREADY LOADED");
    return;
    }
     print("NOT YET LOADED");
    try {
      final res = await DBProvider.db.getAllTransactions();
      if (res == null) {
        print('RES IS NULL ');

        return null;
      }
      res.forEach(
        (element) => _transactions.add(Transaction(
          amount: element['amount'],
          date: DateTime.parse(element['date']),
          id: element['id'],
          title: element['title'],
        )),
      );
      setState(() {
        loaded = true;
      });
      int i = 1;
      if (_transactions.length == 0) return;
      print("tran length: ${_transactions.length}");
      _transactions.forEach((element) {
        print("Element $i, id: ${element.id}");
        i++;
      });

      return;
      // if (loaded) return;
      // var prefs = await SharedPreferences.getInstance();
      // if (prefs == null || !prefs.containsKey('data')) {
      //     setState(() {
      //       loaded = true;
      //     });
      //     return ;
      // }

      // var fetchedData = prefs.get('data');
      // var userData = json.decode(fetchedData) as Map<String, dynamic>;

      // List<Transaction> myTransactions = (userData['list'] as List<dynamic>)
      //     .map((tran) => Transaction(
      //           amount: tran['amount'],
      //           date: DateTime.parse( tran['date'] ),
      //           id: tran['id'],
      //           title: tran['title'],
      //         ))
      //     .toList() as List<Transaction>;

      // _transactions = myTransactions;
      // setState(() {
      //    loaded = true;
      // });

    } catch (error) {
      print(error.toString());
      print("Error while loading transactions.");
      setState(() {
        loaded = true;
      });
    }
  }

  List<Widget> _buildLandscape(availableSpace, txWidget) {
    // List<Widget> _listOfTransactions = [];
    //_loadTransactions().then((_) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Show chart: "),
          Switch(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: availableSpace * (0.6), child: Chart(_recentTransactions))
          : txWidget
    ];
  }
  //);
  //  return _listOfTransactions;

  List<Widget> _buildPortrait(availableSpace, txWidget) {
    // _loadTransactions().then((_) {
    return [
      Container(
          height: availableSpace * (0.3), child: Chart(_recentTransactions)),
      txWidget
    ];
    //  });
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);

    var appBar = AppBar(
      title: Text("Personal expences app"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _startAddNewTransaction(context);
          },
        )
      ],
    );

    final availableSpace = _mediaQuery.size.height -
        _mediaQuery.padding.top -
        appBar.preferredSize.height;
    final _isLandscape = _mediaQuery.orientation == Orientation.landscape;

    var txWidget = Container(
        height: availableSpace * (0.7),
        child: TransactionList(_transactions, deleteTransaction));

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _loadTransactions(),
          builder: (context, snapshot) => loaded == false
              ? Center(child: CircularProgressIndicator())
              : Column(
                  //mainAxisAlignment: MainAxisAlignment.start//po defaltu je postavljen na start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (_isLandscape)
                      ..._buildLandscape(availableSpace, txWidget),
                    if (!_isLandscape)
                      ..._buildPortrait(availableSpace, txWidget),
                  ],
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // await _saveTransactions();
          _startAddNewTransaction(context);
        },
      ),
    );
  }
}
