import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overlay_support/overlay_support.dart';

Widget CustomDropDown(
    List<String> items,
    String value,
    void onChange(val)
){
  return InkWell(
    onTap: (){
      if(items.isEmpty){
        showSimpleNotification(
          Text('No Internet Connection!'),
          background: Colors.red,
        );
      }
    },
    child: Container(

      padding: EdgeInsets.symmetric(vertical: 4,horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
    child: DropdownButton<String>(
      value: value.isEmpty?null :value,
          onChanged: (val){
            onChange(val);
          },
      items: items.map<DropdownMenuItem<String>>((String val){
        return DropdownMenuItem(
          child: Text(val,),
          value: val,
        );
      }).toList(),
    ),
    ),
  );
}