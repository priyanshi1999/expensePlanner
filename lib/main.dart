import 'package:expense_planner/widgets/models/transaction.dart';
import 'package:expense_planner/widgets/widgets/chart.dart';
import 'package:expense_planner/widgets/widgets/new_transaction.dart';
import 'package:expense_planner/widgets/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',

      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        //accentColor: Colors.grey,
        fontFamily: 'Quicksand',

        textTheme: ThemeData.light().textTheme.copyWith(
          title:TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),

        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith
          (title: TextStyle(
            fontFamily: 'Open Sans',
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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  

  final List<Transaction> _userTransactions=[

    /* Transaction
    (id:'t1',
    title:'Pink Ribbed Top',
    amount:525,
    date:DateTime.now(),
    ),  */

    //Transaction(
      //id:'t2',
      //title:'Damaged Blue Jeans',
      //amount:750,
      //date:DateTime.now(),
      //),

  ];

   List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx){
      //if i subtract 7 days from today's date then i'll get recent transactions of 7 days.
      return tx.date.isAfter(DateTime.now().subtract(
          Duration(days:7),
        ),
      );
    }).toList();
  } 

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate){
    //just for purpose of getting a unique id we have used date time in id as well (along with date)
    final newTx=Transaction(
      id:DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      //date: DateTime.now()
      date: chosenDate
      );

      //we want to add the new transaction to the list and update it on the ui, so we will write it inside setState func.
      setState(() {
        _userTransactions.add(newTx);
      });
  
  }

  void _startAddNewTransaction(BuildContext ctx){
    //showModalBottomSheet requires context and build. We can get context with the help of BuildContext and hence we have
    //written BuildContext ctx as arguement in the function.
    showModalBottomSheet(context: ctx, 
    builder: (bctx) {
      return NewTransaction(_addNewTransaction);
  },
  );
}

void _deleteTransaction(String id){
  //String id is the ID of the transaction to be deleted
  setState(() {
    _userTransactions.removeWhere((tx){
      //we have to return true if it is the element that we want to remove which is the case if the id of the element
      //we are looking at is same as the id that we are getting here
      return tx.id ==id;
    });
  });
}

  @override
  Widget build(BuildContext context) {
    print('userTransactionInMain');
    print(_userTransactions.toList());
    print('recentTransactionToBePassedToChartInMain');
    print(_recentTransactions);
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App', 
        //style: TextStyle(fontFamily: 'Open Sans'),
        ), 
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
          ),
        ],
      ),
      body:SingleChildScrollView(
       child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[

        //Chart constructor takes transactions upto 7 days so we have created a new list here with getter which
        //generates recent transactions upto 7 days.
        Chart(_recentTransactions),

        TransactionList(_userTransactions, _deleteTransaction),
  
      ],
      ),
      ),

      floatingActionButton: FloatingActionButton(
       child:Icon(Icons.add),
       //foregroundColor:Theme.of(context).primaryColor,
       onPressed: () => _startAddNewTransaction(context),
      ),
    );

  }
}
