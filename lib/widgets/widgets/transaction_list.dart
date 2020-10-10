import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty ? 
    LayoutBuilder(builder: (ctx, constraints) {
          return Column(
          children:<Widget>[
            Text('No transactions added!',
            style:Theme.of(context).textTheme.title
            ),

            const SizedBox(
              height: 30
              ),

            Container(
              //to adjust the height of the image
              height: constraints.maxHeight * 0.6,
              child: Image.asset('assets/images/nodATA.png',
              fit: BoxFit.cover
              ),
            ),
          ],
        );
    })
      :
       /* ListView.builder(
        itemBuilder: (context,index) {
           return TransactionItem(
             transaction: transactions[index],
             deleteTx: deleteTx
          );
        },
        itemCount: transactions.length,
      ); */

      //we have commented the above part of ListView.builder to make use of 'keys'
      ListView(
        children: transactions.map((tx) => TransactionItem(
          key: ValueKey(tx.id),
          transaction: tx,
          deleteTx: deleteTx,
        ))
        .toList());
    
  }
}

