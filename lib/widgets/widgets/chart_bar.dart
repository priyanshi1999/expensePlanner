import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {

  //label for denoting the week day
  final String label;
  final double spendingAmount;
  //spendingPercentageOfTotal to determine how much background of the bar should be colored.
  final double spendingPercentageOfTotal;

  const ChartBar(this.label,this.spendingAmount,this.spendingPercentageOfTotal);

  @override
  Widget build(BuildContext context) {
    //we need to calculate height of bars dynamically. And we will do that by making use of constraints from
    //LayoutBuilder
    return LayoutBuilder(builder: (context,constraints) {

    return Column(
      children: <Widget>[
        Container(
          //height: 20,
          height:constraints.maxHeight *0.15,
          child: FittedBox(
               child: Text(
               '₹'+spendingAmount.toStringAsFixed(0),
               style: TextStyle(
               color: Colors.black,
               fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        SizedBox(
          //height:4
          height:constraints.maxHeight *0.05,
        ),
        Container(
          //height: 80,
          height:constraints.maxHeight *0.6,
          width: 15,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  //to set border color and width
                  border:Border.all(
                    color:Colors.white,width:1
                  ),
                  //to give white background
                  color: Color.fromRGBO(211, 211, 211, 1),
                  //to give curved edges
                  borderRadius: BorderRadius.circular(15),
                  ),
              ),
              
              FractionallySizedBox(
                heightFactor: spendingPercentageOfTotal,
                child: Container(
                  decoration: BoxDecoration(
                  //color:Color.fromRGBO(211, 211, 211, 1),
                  color:Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.circular(15)
                ),
              ),
              ),
            ],
          ),
        ),
        SizedBox(
          //height:4
          height:constraints.maxHeight *0.05,
        ),
        Container(
          height:constraints.maxHeight *0.15,
          child: FittedBox(
              child: Text(
              label,
              style: TextStyle(
               color: Colors.black,
               fontWeight: FontWeight.bold
               ), 
            ),
          ),
        ),
      ],
    );

    },
    ); 
  }
}