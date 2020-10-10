import 'dart:math';

import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgCircleAvatarColor;

//we have used initState to set some initial dynamic data. Whenever a new transaction is added, it'll be added 
//with a different color of circleAvatar
  @override
  void initState() {
    const availableColors=[Colors.black, Colors.orange, Colors.grey, Colors.deepOrangeAccent];
    _bgCircleAvatarColor=availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical:8,horizontal:5),
      elevation: 8,
        child: ListTile(
        leading: CircleAvatar(
          radius:40,
          //backgroundColor: Colors.deepOrangeAccent,
          backgroundColor: _bgCircleAvatarColor,
          child:Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
                 child: Text(
                '₹'+widget.transaction.amount.toStringAsFixed(2),
                style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold)
              ),
            ),
          ),
      ),
      title: Text(
        widget.transaction.title,  
        style: Theme.of(context).textTheme.title
      ),
      subtitle: Text(
        DateFormat.yMMMd().format(widget.transaction.date),
        style: TextStyle(color:Colors.grey,fontSize:13)
      ),

      //if width of our device is greater than 360 then we want a text 'delete' along with the delete icon.
      trailing: MediaQuery.of(context).size.width > 360 ?
      FlatButton.icon(
      icon: const Icon(Icons.delete),
      label: const Text('Delete'),
      textColor: Colors.deepOrangeAccent,
      //in main.dart _deleteTransaction requires an ID but deleteTx expects void, hence we have wrapped it in an
      //anonymous function and then passed the id as argument.
      onPressed: () => widget.deleteTx(widget.transaction.id),
      )
      //if width of our device is less than 360 then we want only a button with delete icon.
      :
      IconButton(
      icon: const Icon(Icons.delete),
      color: Colors.deepOrangeAccent,
      //in main.dart _deleteTransaction requires an ID but deleteTx expects void, hence we have wrapped it in an
      //anonymous function and then passed the id as argument.
      onPressed: () => widget.deleteTx(widget.transaction.id),
      ),
      ),
    );
  }
}