import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:expense_planner/widgets/models/transaction.dart';
import 'package:expense_planner/widgets/widgets/chart.dart';
import 'package:expense_planner/widgets/widgets/new_transaction.dart';
import 'package:expense_planner/widgets/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

void main() { 

  //to not allow the app to be in landscape mode. It'll always be in portrait mode
  /* WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
    ]); */
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Platform.isIOS ? 

    CupertinoApp(
      title: 'Flutter App',
      theme: CupertinoThemeData(
        //do what you want 
      ),
    )
     : 
    MaterialApp(
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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  bool _showChart=false;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    print(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
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
    showModalBottomSheet(
    context: ctx, 
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

List <Widget> _builderMethodForLandscapeContent(MediaQueryData mediaQuery, AppBar appBarr,Widget transactionListWidget){
  //we can return only one value (widget) inside a function.
 return [Row(
    //depending on the switch, whether it is turned on or not our UI will change for which we need to be in a
    //stateful widget, and fortuantely we already are in it :)
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
     Text('Show chart',
     style: Theme.of(context).textTheme.title
    ),
    Switch.adaptive
    (
     activeColor: Colors.deepOrangeAccent,
     value: _showChart, onChanged: (val){
     setState(() {
     _showChart=val;
     });
    })
    ],
  )
  ,
  //if _showChart is true then display chart
   _showChart?
         Container(
           //'MediaQuery.of(context).padding.top' - to deduct height of status bar
          height: (mediaQuery.size.height - appBarr.preferredSize.height - mediaQuery.padding.top)*0.7,
          //Chart constructor takes transactions upto 7 days so we have created a new list here with getter which
          //generates recent transactions upto 7 days.
          child: Chart(_recentTransactions),
         )
        //if _showChart is false then display list of transactions.
        :
        transactionListWidget
  ];
}

List <Widget> _builderMethodForPortraitContent(MediaQueryData mediaQuery, AppBar appBarr,Widget transactionListWidget){
  //we can return only one value (widget) inside a function.
   return [Container(
    height: (mediaQuery.size.height - appBarr.preferredSize.height - mediaQuery.padding.top) * 0.3,
    //Chart constructor takes transactions upto 7 days so we have created a new list here with getter which
    //generates recent transactions upto 7 days.
    child: Chart(_recentTransactions),
    )
    ,
    transactionListWidget
   ];
}

Widget _builderMethodForCupertinoAppBar(){

  return CupertinoNavigationBar(
      middle: Text('Personal Expense'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          //we cannot add icon button here inside cupertinoNavigationBar because ancestor of item buttom should
          //implement material design, which is not the case here. So we will create our own new custom button.
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap:() => _startAddNewTransaction(context),
          )

        ],
      ),
    ); 

}

Widget  _builderMethodForNormalAppBar(){
 return AppBar(
        title: Text('Personal Expense', 
        ), 
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
          ),
        ],
      );
}


  @override
  Widget build(BuildContext context) {

    final mediaQuery=MediaQuery.of(context);

    //to check whether orientation is landscape or not. 'isLandscape' is a boolean which will be true if orientation
    //is landscape. We will shoe the switch only if orientation is landscape.
    final isLandscape=mediaQuery.orientation==Orientation.landscape;

    //we have created a new appBar variable named as appBarr so that we can use its height and
    //deduct it from different widgets whenever required.

    //we have explicity defined appBarr type to be PreferredSizeWidget because dart wasn't able to find out.
    final PreferredSizeWidget appBarr= Platform.isIOS ? 
     _builderMethodForCupertinoAppBar()
   /*  CupertinoNavigationBar(
      middle: Text('Personal Expense'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          //we cannot add icon button here inside cupertinoNavigationBar because ancestor of item buttom should
          //implement material design, which is not the case here. So we will create our own new custom button.
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap:() => _startAddNewTransaction(context),
          )

        ],
      ),
    ) :  */
    :
    _builderMethodForNormalAppBar();
    //AppBar(
      /*   title: Text('Personal Expense', 
        ), 
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
          ),
        ],
      ); */

      final transactionListWidget=
      Container(
          height: (mediaQuery.size.height - appBarr.preferredSize.height
          - mediaQuery.padding.top)*0.7,
          child: TransactionList(
            _userTransactions, _deleteTransaction
          ),
      );

       final appBody = SafeArea(child:SingleChildScrollView(
         
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          //we do not use curly braces with if inside list (here list of widgets)
           if(isLandscape)
           ..._builderMethodForLandscapeContent(mediaQuery,appBarr,transactionListWidget), 

          if(!isLandscape)
          ..._builderMethodForPortraitContent(mediaQuery,appBarr,transactionListWidget),
        
      ],
      ),
      ),
       );

    return Platform.isIOS ? 
    CupertinoPageScaffold(
      child: appBody,
      navigationBar: appBarr ,
    ) 
    : 
    Scaffold(
      appBar: appBarr,
      body: appBody,
      
      floatingActionButton: 
      Platform.isIOS 
      ? 
      Container() 
      :
      FloatingActionButton(
       child:Icon(Icons.add),
       //foregroundColor:Theme.of(context).primaryColor,
       onPressed: () => _startAddNewTransaction(context),
      ),
    );

  }
}
