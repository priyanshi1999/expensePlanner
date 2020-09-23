import 'package:flutter/foundation.dart';

class Transaction{
  //We'll have a string (title of our transaction), the amt of our transaction, and the date.
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Transaction({
    //in order to use this decorator "@required" we have to import flutter/foundation.dart
    @required this.id, 
    @required this.title, 
    @required this.amount, 
    @required this.date
    });
}