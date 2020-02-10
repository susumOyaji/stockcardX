import 'package:flutter/material.dart';
//import 'dart:async';
import 'main.dart';
//import 'ViewModel/Finance.dart';
 




 //Nikkey And NewYork Dow Display
class MaketStandard extends StatelessWidget{
  MaketStandard({this.stdwidgets});
  final List<Price> stdwidgets;// = new List.generate(2, (index) => index);
  //stdwidgets[0].polar ?? false;
 
  @override
  Widget build(BuildContext context) {
  //Widget marketStandard(int i){
  return  SafeArea(
    /*
    height: 65.0,
      decoration: BoxDecoration(
        color: Color.fromARGB(0xFF, 0x0B, 0x39, 0x50),
      ),
      margin: const EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0), //.all(4.0),
      */
      //padding: new EdgeInsets.all(0.0), 
      child: Column(children:[
        //Column(children: [
        Chip(
          //key: chipKey,
          backgroundColor: Color(0XFF8069A1),
          elevation: 10,
          shadowColor: Colors.black,
          //padding: EdgeInsets.all(10),
          avatar: CircleAvatar(
            backgroundColor: Colors.green,
          ),
          label: Text('Nikkei :${stdwidgets[0].getrealValue}'+'前日比 :${stdwidgets[0].prevday}'+'変動率 :${stdwidgets[0].percent}',
          //style: new TextStyle(fontFamily: 'RobotoMono',fontSize: 10.0),),
          style: TextStyle(color: Color(0XFFACACAE),
            fontSize:10.0,
            fontWeight: FontWeight.bold),),
        ),
         Chip(
          //key: chipKey,
          backgroundColor: Color(0XFF8069A1),
          elevation: 10,
          shadowColor: Colors.black,
          //padding: EdgeInsets.all(10),
          avatar: CircleAvatar(
            backgroundColor: Colors.green,
          ),
          label: Text('NY Dow:${stdwidgets[1].getrealValue}'+'前日比 :${stdwidgets[1].prevday}'+'変動率 :${stdwidgets[1].percent}',
          //style: new TextStyle(fontFamily: 'RobotoMono',fontSize: 10.0),),
          style: TextStyle(color: Color(0XFFACACAE),
            fontSize:10.0,
            fontWeight: FontWeight.bold),),
        ),
          
      ],
      ),
      );
    
}
}//market