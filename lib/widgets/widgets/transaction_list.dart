import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      child:transactions.isEmpty ? Column(
        children:<Widget>[
          Text('No transactions added!',
          style:Theme.of(context).textTheme.title),
          SizedBox(
            height: 30
            ),
          Container(
            height: 200,
            child: Image.asset('assets/images/nodATA.png',
            fit: BoxFit.cover
            ),
          ),
        ],
      ):
       ListView.builder(
        itemBuilder: (context,index) {
         
           return Card(
             margin: EdgeInsets.symmetric(vertical:8,horizontal:5),
             elevation: 8,
               child: ListTile(
               leading: CircleAvatar(
                 radius:40,
                 backgroundColor: Colors.deepOrangeAccent,
                 child:Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: FittedBox(
                        child: Text(
                       '₹'+transactions[index].amount.toStringAsFixed(2),
                       style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold)
                     ),
                   ),
                 ),
             ),
             title: Text(
               transactions[index].title,  
               style: Theme.of(context).textTheme.title
             ),
             subtitle: Text(
               DateFormat.yMMMd().format(transactions[index].date),
               style: TextStyle(color:Colors.grey,fontSize:13)
             ),
             trailing: IconButton(
             icon: Icon(Icons.delete),
             color: Colors.deepOrangeAccent,
             //in main.dart _deleteTransaction requires an ID but deleteTx expects void, hence we have wrapped it in an
             //anonymous function and then passed the id as argument.
             onPressed: () => deleteTx(transactions[index].id),
             ),
             ),
           );
        },

        itemCount: transactions.length,

         ),
    );
    
  }
}