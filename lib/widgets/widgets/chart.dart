import 'package:expense_planner/widgets/models/transaction.dart';
import 'package:expense_planner/widgets/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {

  //recentTransactions means transactions upto 7 days.
  //recentTransactions are the transactions that happened last week.

  final List <Transaction> recentTransactions;

  Chart(this.recentTransactions);

  //here we have a list of maps. And map contains string and object.
  List <Map <String,Object> > get groupedTransactionValues{

    //7= no of week days.
    //index=0,1,2,3,4,5,6

    return List.generate(7, (index) {

      //we have recentTransactions (transactions which happened last week) and we will find weekDay transaction total with
      // the help of for loop & totalSum to fill in the bar chart.

      final weekDay=DateTime.now().subtract(Duration(days:index));
      double totalSum=0.0;


      //this loop will run till we have transactions. We have to find total transactions.
      for(var i=0; i<recentTransactions.length; i++){

        //To identify whether the recentTransaction happened on that day (today)

        if(recentTransactions[i].date.day == weekDay.day && 
        recentTransactions[i].date.month == weekDay.month &&
        recentTransactions[i].date.year == weekDay.year){
          totalSum = totalSum + recentTransactions[i].amount;
        }
      }

      //now we dont want the entire date, which we will get from DateTime.now, rather we are only interested in
      //week day.So DateFormat.E() by default gives us short form of our week days.


      //totalSum gives total of that particular day 
      print('Total sum: '+totalSum.toString());
      print('Date: '+DateFormat.E().format(weekDay));

      return {'day':DateFormat.E().format(weekDay).substring(0,1),'amount':totalSum};

    }).reversed.toList();
  }

  double get totalSpending{

    //here we want to return a value based on our groupedTransactionValues
    //groupedTransactionValues is a list and here we need a double as return, so we will make use of fold

    //return groupedTransactionValues.fold(initialValue, (previousValue, element) => null)
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum+item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    /* print('recentTransactions');
    print(recentTransactions);
    print('groupedTransactions');
    print(groupedTransactionValues); */
    return Card(
      
      color: Colors.white,
      margin: EdgeInsets.all(20),
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((dataaa){
            //return Text(dataaa['day'].toString()+':'+dataaa['amount'].toString(), 

            //now we need percentageTotalSpending as it is required in ChartBar constructor. So we will calculate that
            //using another getter.
            //dataaa['amount'] is an object and we cannot apply divide operation on an object so "as double"
            return Flexible(
              fit: FlexFit.tight,
              child: (
               ChartBar(dataaa['day'], dataaa['amount'],
               totalSpending==0.0 ? 0.0 : ((dataaa['amount'] as double) / totalSpending)
               )
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}