
import 'package:flutter/material.dart';

bool isNumeric(String s){
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;

}

void mostarAlerta(BuildContext context,String message){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    }
  );    
}



