import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {

  final Function addTx;
  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {

  final _titleController=TextEditingController();
  final _amountController=TextEditingController();
  //this DateTime variable isn't final because it will change as per what the user chooses
  DateTime _selectedDate;

  void _submitData(){

    final enteredTitle=_titleController.text;
    final enteredAmount=double.parse(_amountController.text);

    if(enteredTitle.isEmpty || enteredAmount<=0 || _selectedDate==null){
     return;
    }

    widget.addTx(enteredTitle,enteredAmount,_selectedDate);
    //print('Title is: '+enteredTitle);
    //print('Amount is: '+enteredAmount.toString());

    Navigator.of(context).pop();

  }

  void _presentdatePicker(){
    showDatePicker(
    context: context,
    initialDate: DateTime.now(), 
    firstDate: DateTime(2020), 
    lastDate: DateTime.now()
    ).then((pickedData){

      if(pickedData==null){
        return;
      }
      else{
        //because we want the ouput to be actually visible on UI hence inside setState
        setState(() {
          _selectedDate=pickedData;
        });
      }
      
    });
  }

  @override
  Widget build(BuildContext context) {

    return Card(
          elevation: 5,
         child: Container(
           padding: const EdgeInsets.all(10),
           child: Column(
             //To get the button "add transaction" to the right side.
             crossAxisAlignment: CrossAxisAlignment.end,
             children: <Widget>[
               TextField(decoration: InputDecoration(labelText: 'Enter title here..'),
               onSubmitted: (_) => _submitData(),
               //onChanged: (value){
                 //inputTitle=value;
               //},
               controller: _titleController,
               ),
               TextField(decoration: InputDecoration(labelText: 'Enter amount here..',),
               keyboardType: TextInputType.number,
               onSubmitted: (_) => _submitData(),
               //onChanged: (value){
                 //inputAmount=value;
               //},
               controller: _amountController,
               ),
               Container(
                 height: 70,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     FlatButton(
                       child: Text(
                       'Choose date', 
                       style:TextStyle(fontWeight: FontWeight.bold)
                     ),
                     textColor: Colors.deepOrangeAccent,
                     onPressed: _presentdatePicker,
                     ),
                     Text(
                      _selectedDate==null ? 'No date chosen'
                      : DateFormat.yMd().format(_selectedDate),
                     style:TextStyle(color: Colors.grey)
                     ),
                   ],
                 ),
               ),
               SizedBox(height: 20),
               FlatButton(
                 //color: Colors.deepPurple,
                 color:Theme.of(context).primaryColor,
                 child:Text('Add Transaction',textAlign: TextAlign.center,),
                 textColor: Colors.white,
                 onPressed: (){
                  _submitData();
                 },
               ),
             ],
           ),
         ),
        );
        
  }
}
