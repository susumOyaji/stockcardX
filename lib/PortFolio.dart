
import 'package:flutter/material.dart';
//import 'main.dart';



   //Parsonal Data Disp
  class PortFolio extends StatelessWidget{
    PortFolio({this.portassetPrice, this.portassetTotal, this.portassetvalue});
    final String portassetPrice; 
    final String portassetTotal ;
    final String portassetvalue;

     
   
      
      @override
      Widget build(BuildContext context) {
      return new SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Chip(
              //key: chipKey,
              backgroundColor: Color(0XFF8069A1),
              elevation: 10,
              shadowColor: Colors.black,
              //padding: EdgeInsets.all(10),
              avatar: CircleAvatar(
                backgroundColor: Colors.green,
              ),
              label: Text('投資総額 :${portassetTotal.toString()}'+"  "+"評価総額:${portassetPrice.toString()}"+"  "+"損益${portassetvalue.toString()}",
              //style: new TextStyle(fontFamily: 'RobotoMono',fontSize: 10.0),),
              style: TextStyle(color: Color(0XFFACACAE),
              fontSize:10.0,
              fontWeight: FontWeight.bold),),
            ),
        ],),
      );
    }
}
