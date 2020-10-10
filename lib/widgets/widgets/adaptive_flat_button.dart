import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class AdaptiveFlatButton extends StatelessWidget {

  final Function getDatePicker;
  AdaptiveFlatButton(this.getDatePicker);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS? CupertinoButton(
     child: Text(
      'Choose date', 
       style:TextStyle(fontWeight: FontWeight.bold)
      ),
       onPressed: getDatePicker,
      ) 
      : 
      FlatButton(
       child: Text(
       'Choose date', 
       style:TextStyle(fontWeight: FontWeight.bold)
      ),
       textColor: Colors.deepOrangeAccent,
       onPressed: getDatePicker,
    );
  }
}