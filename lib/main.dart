import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'shared_prefs.dart';

import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
//import 'package:file_chooser/file_chooser.dart' as file_chooser;

//import 'dart:async';
//import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'MarketStandard.dart';
import 'PortFolio.dart';
//import 'Appreciation.dart';
import 'NetConnect.dart';




void main()async{
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
	return new MaterialApp(
    debugShowCheckedModeBanner: false,  // <- Debug の 表示を OFF
		title: 'Flutter Demo',
		theme: new ThemeData(
		primarySwatch: Colors.blue,
	  ),
	  home: new MyHomePage(),
	);
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,}) : super(key: key);
  
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}


 void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}
 
 
 
 
 
 //カンマ区切り文字列を整数に変換
  int toIntger(String char){
	   String row="";
	  List<String> sp = char.split(",");

	  if (char == "---") return 0;
	  for(int i = 0 ;i < (sp.length);++i ) {
		row += sp[i];
	  }

	  int num = int.parse(row);
	  return num;
  }





 String separation(int number){
      final matcher = new RegExp(r'(\d+)(\d{3})');

      String first_part = number.toString();
      while ((first_part).contains(matcher)) {
        first_part = (first_part.replaceAllMapped(matcher, (m) => '${m[1]},${m[2]}') );
      }
      print('first_part: $first_part');
      return first_part;
  }


 
  



class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController = new TextEditingController();
  List widgets=[];// new List<Price>.filled(1, Price());
  
  List<List<String>> rategets = [];
  List volumegats = [];
	List<String> total = []; 	
   
  
  StorageControl storageControl;
  bool _isComposing = false; 
  bool rategetsbool = false;
  String  _repositories1;
   int i = 0;
  String responceBuff;
  String assetTotal;
  String assetPrice;
  
  String assetValue;
  String returncode="ソニー";


////////////////////////////////
List<String> codeItems = []; //codekey
List<String> stockItems = [];//stock
List<String> valueItems = []; //value



List<String> acquiredAssetsItems = [];//取得資産 stock x value
List<String> valuableAssetsItems = [];//評価資産 stock X presentvalue
List<String> acquiredAssetsSumString = [];
List<String> valuableAssetsSumString = [];
int acquiredAssetsSum = 0;//取得資産合計
int valuableAssetsSum = 0;//評価資産合計


String valueSum;
String presentvalueSUm;

bool _validateCode = false;
bool _validateStock = false;
bool _validateValue = false;

final TextEditingController codeCtrl = TextEditingController();
final TextEditingController stockCtrl = TextEditingController();
final TextEditingController valueCtrl = TextEditingController();


static String code; //
  static String presentvalue = "non"; //現在値
  static String changePriceRate = "non"; //前日比%
  static String changePriceValue = "non"; //前日比¥
  static bool signalstate = true; //Up or Down

  var _chipListfast = List<Chip>();
  var _chipList = List<Chip>();
  var _keyNumber = 0;
  var _keyNumberfast = 0;
  String price = "";
  String codename; //="Null to String";
  int intprice=0;
  int index=0;
  bool purchase = false;
  String stringprice ="";
  String gain="0";
  bool _active = false;


   void _init() async {
    await SharePrefs.setInstance();

    codeItems = SharePrefs.getCodeItems();
    stockItems = SharePrefs.getStockItems();
    valueItems = SharePrefs.getValueItems();
    acquiredAssetsItems = SharePrefs.getacquiredAssetsItems();//取得資産
    valuableAssetsItems = SharePrefs.getvaluableAssetsItems();



    await loadDatafast("998407.O");
    await loadDatafast("^DJI");
    
    await loadData();
    
  }








  @override
  void initState() {
	  super.initState();
    _init();
	  //getwidgets[0].polar=false; //起動時のNull対策、読込データ準備待ち
    //rategets[0][1]="";
    //_setTargetPlatformForDesktop();
	  reload1();
    //getBody();
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return setupDisp();
    }
  }

  

  getProgressDialog() {
    return new Center(child: new CircularProgressIndicator());
  }

  showLoadingDialog() {
    if (widgets.length == 0) {
      return true;
    }
      return false;
  }


  setupDisp() {
   //historyDivider();
   return base();
  }


  void reload1()async{
    intprice=0;
    index=0;
    purchase = true;

    for (String codes in codeItems) {
      await fetch(codes);
      //_addChip(code, presentvalue, changePriceRate);
    }
    
    //_addChipfast("Gain:",gain,"   取得額: "+valueSum, "   評価額: "+presentvalueSUm);

    //getwidgets = await fetch(codeItems);//getserchi1();NetConnect.dart
    widgets = await fetch(code);
    rategets = await riseRate1();
	  volumegats = await volumeranking1();
    
    setState(() {
      widgets=widgets;
      rategets=rategets;
      rategetsbool=true;

    });
  }


  void _changeSwitch(bool e) => setState(() => _active = e);

  addfetch(String codes) async {
    await fetch(codes);
    //_addChip(codes, presentvalue, changePriceRate);
  }


  loadDatafast(String codes) async {
    //String responce ="6758,200,1665\n6976,400,1746\n395,0,0\n";
    //_incrementCounter();
    await fetch(codes);
    _addChipfast(code, "  "+presentvalue, "  "+changePriceRate,"");
    
  }

  loadData() async {
    //String responce ="6758,200,1665\n6976,400,1746\n395,0,0\n";
    //_incrementCounter();
    intprice=0;
    index=0;
    purchase = true;

    for (String codes in codeItems) {
      await fetch(codes);
      //_addChip(code, presentvalue, changePriceRate);
    }
    
    //_addChipfast("Gain:",gain,"   取得額: "+valueSum, "   評価額: "+presentvalueSUm);
  }

  void _addChipfast(String code,String presentvalue, String beforeratio,String gain) {
    var chipKey = Key('chip_key_$_keyNumberfast');
    _keyNumberfast++;

     
    _chipListfast.add(
      Chip(
        key: chipKey,
        backgroundColor: Color(0XFF8069A1),
        elevation: 4,
        //shadowColor: Colors.white,
        padding: EdgeInsets.all(4),
        avatar: CircleAvatar(
          backgroundColor:  signalstate ? Colors.red : Colors.green,
        ),
        label: Text(code + presentvalue + beforeratio + gain,
          style: TextStyle(color: Color(0XFFACACAE),
            fontSize:12.0,
            fontWeight: FontWeight.bold)
        ),
      ),
    );
  }


  void _addChip(String code, String presentvalue, String deforerasio) {
    //var chipKey = Key('chip_key_$_keyNumber');
    var chipKey = Key("$_keyNumber");
    _keyNumber++;

    _chipList.add(
      Chip(
        key: chipKey,
        backgroundColor: Color(0XFF12445D),
        elevation: 8,
        //shadowColor: Colors.white,
        //padding: EdgeInsets.all(4),
        avatar: CircleAvatar(
          maxRadius: 10.0,
          backgroundColor:
              signalstate ? Colors.red : Colors.green,
          child: Text(_keyNumber.toString()),
        ),
        label: Text(code + " " + presentvalue + "  " + deforerasio,
            style: TextStyle(
                color: Color(0XFFACACAE),
                fontSize: 10.0,
                fontWeight: FontWeight.bold)
        ),
        
        //onSelected：() => _deleteChip(chipKey),
        //onPressed:() => _deleteChip(chipKey),
        //deleteButtonTooltipMessage: "dellete",
        onDeleted: () => _deleteChip(chipKey),
      ),
    );
  }


  void _deleteChip(Key chipKey) {
    setState(() => _chipList.removeWhere((Widget w) => w.key == chipKey));
    ValueKey<String> listJsonData = chipKey;
    int _index = int.parse(listJsonData.value);
    
    codeItems.removeAt(_index);stockItems.removeAt(_index);valueItems.removeAt(_index);
    SharePrefs.setCodeItems(codeItems);SharePrefs.setStockItems(stockItems);SharePrefs.setValueItems(valueItems);
    setState(() {
      _keyNumber--;
      
    });
  }


  _reloadData() async {
    index=0;
    for (String codes in codeItems) {
      codes= codes+".T";
      await fetch(codes);
      //_addChip(code, presentvalue, beforeratio);
    }
    setState(() {
      
    });
  }


  Widget _titleArea() {
    return Container(
      color: Color(0xFF0B4050),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              runSpacing: 0.0,
              direction: Axis.horizontal,
              children:  _chipListfast,
            ),
          ),
        ],
      ),
    );
  }


  Widget _titleArea1() {
    return Container(
        height: 35.0,
        color: Color(0xFF0B4050),
        //margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Row(
          // 1行目
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                //padding: EdgeInsets.all(1.0),
                //height: 70.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey,
                ),
                child: TextField(
                  controller: codeCtrl,
                  decoration: InputDecoration(
                    labelText: 'CodeNumber',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        //height: 1,
                        fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                    errorText: _validateCode ? 'The CodeNumber input is empty.' : null,
                    contentPadding: const EdgeInsets.only(
                        left: 0.0, bottom: 15.0, top: 15.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellowAccent),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  autocorrect: false,
                  onSubmitted: (text) {
                    if (text.isEmpty) {
                      _validateCode = true;
                      setState(() {});
                    } else {
                      _validateCode = false;
                      codeItems.add(text);
                      codeCtrl.clear();
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                // height: 70.0,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey,
                ),
                child: TextField(
                  controller: stockCtrl,
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        //height: 1,
                        fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                    errorText:
                        _validateStock ? 'The Stock input is empty.' : null,
                    contentPadding: const EdgeInsets.only(
                        left: 0.0, bottom: 15.0, top: 15.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  autocorrect: true,
                  onSubmitted: (text) {
                    if (text.isEmpty) {
                      _validateStock = true;
                      setState(() {});
                    } else {
                      _validateStock = false;
                      stockItems.add(text);
                      SharePrefs.setStockItems(stockItems).then((_) {
                        setState(() {});
                      });
                      stockCtrl.clear();
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                //height: 70.0,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey,
                ),
                child: TextField(
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.bold),
                  controller: valueCtrl,
                  decoration: InputDecoration(
                    labelText: "value",
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        //height: 1,
                        fontWeight: FontWeight.bold),
                   errorText:
                        _validateValue ? 'The Value input is empty.' : null,
                    contentPadding: const EdgeInsets.only(
                        left: 0.0, bottom: 15.0, top: 15.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  autocorrect: true,
                  onSubmitted: (text) {
                    //TextFieldからの他のコールバック
                    if (text.isEmpty) {
                      _validateValue = true;
                      setState(() {});
                    } else {
                      _validateValue = false;
                      valueItems.add(text);
                      SharePrefs.setValueItems(valueItems).then((_) {
                        setState(() {});
                      });
                      valueCtrl.clear();
                    }
                  },
                ),
              ),
            ),
            InkWell(
                child: Icon(
                  Icons.add_circle,
                  color: Colors.blueAccent,
                  semanticLabel: "",
                ),
                onTap: () {
                  if (/*eCtrl.text.isEmpty ||*/ codeCtrl.text.isEmpty ||
                      stockCtrl.text.isEmpty ||
                      valueCtrl.text.isEmpty) {
                    //if (eCtrl.text.isEmpty) _validate = true;
                    if (codeCtrl.text.isEmpty) _validateCode = true;
                    if (stockCtrl.text.isEmpty) _validateStock = true;
                    if (valueCtrl.text.isEmpty) _validateValue = true;
                    setState(() {});
                  } else {
                    _validateCode = false;_validateStock = false;_validateValue = false;
                    codeItems.add(codeCtrl.text);
                    stockItems.add(stockCtrl.text);
                    valueItems.add(valueCtrl.text);
                    SharePrefs.setCodeItems(codeItems);
                    SharePrefs.setStockItems(stockItems);
                    SharePrefs.setValueItems(valueItems);
                    setState(() {
                      addfetch(codeCtrl.text);
                     
                    });
                            
                    codeCtrl.clear();stockCtrl.clear();valueCtrl.clear();
                  }
                }),
            Switch(
              value: _active,
              activeColor: Colors.orange,
              activeTrackColor: Colors.red,
              inactiveThumbColor: Colors.blue,
              inactiveTrackColor: Colors.green,
              onChanged: _changeSwitch,
            )
          ],
        ));
  }


  Widget _titleArealg() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0B4050),
      ),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
      child: SingleChildScrollView(
        //controller: 
        scrollDirection: Axis.vertical,
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 10.0,
          runSpacing: 10.0,
          direction: Axis.horizontal,
          children: _chipList,
        ),
      ),
    );
  }




  Future fetch(String codes) async {
    final response = await http.get(
        "https://stocks.finance.yahoo.co.jp/stocks/detail/?code="+codes);//+".T"); //^DJI
    final String json = response.body;
    String ret;
    String value;
    String code;
    int intprice;
    String changePriceRate = "non"; //前日比%;
    String changePriceValue = "non"; //前日比¥



 
    RegExp regExp = RegExp(r'<title>.+【');
    setState(() {
          ret = regExp.stringMatch(json).toString();//name
          ret = ret.replaceAll("<title>", "");
          code = ret.replaceAll("【", "");
        print("code-name : " + code);
        });
    
       
        //regExp = RegExp(r'[+-][0-9]{1,}.[0-9]{1,}.[+-]..[0-9]{1,}%.');//日経平均
        //regExp = RegExp(r'[0-9]{1,}[,][0-9]{1,}[.][0-9]{1,}');//DOW平均
        regExp = RegExp(r'[0-9]{1,},[0-9]{1,}'); //1,234;
        setState(() {
          value = regExp.stringMatch(json).toString();//現在値
          presentvalue = value;
        });
        print("StockPrice : " + value);
        print("string to int : " + intprice.toString());
        print("hasMatch : " + regExp.hasMatch(json).toString());
        
    
        //regExp = RegExp(r'[+-][0-9]{1,}.[+-]..[0-9]{1,}%.'); 
        //regExp = RegExp(r'[+-][0-9]{1,}.[0-9]{1,}.[+-]..[0-9]{1,}%.');//日経平均
        regExp = RegExp(r'["][+-][0-9]{1,}[.][0-9]{1,}');//DOW前日比¥
        setState(() {
          String change = regExp.stringMatch(json).toString();
          change = change.replaceAll('"', "");
          changePriceRate = change; //前日比%
          print("Change : " + changePriceRate);
        });
        print("Change : " + regExp.hasMatch(json).toString());
    
        regExp = RegExp(r'["][+-][0-9]{1,}[.][0-9]{1,}');//DOW前日比%
        setState(() {
          String change = regExp.stringMatch(json).toString();
          change = change.replaceAll('"', "");
          changePriceValue = change; //前日比%
          print("ChangeValue : " + changePriceRate);
        });
        print("ChangeValue: " + regExp.hasMatch(json).toString());
    
    
    
    
        if (purchase == true){
          try {
            intprice = intprice + int.parse(value.replaceAll(",", ""));//string for int
          } catch (exception) {
            intprice = 0;
          }
          acquiredAssetsItems.add((int.parse(stockItems[index]) * int.parse(valueItems[index])).toString());//取得資産
          
          try{
            valuableAssetsItems.add((int.parse(value.replaceAll(",", "")) * int.parse(stockItems[index])).toString());//評価資産
          }catch(exception){
            valuableAssetsItems.add("0");
          }
    
          setState(() {
            acquiredAssetsSum = acquiredAssetsSum + int.parse(acquiredAssetsItems[index]);//取得資産合計
            valueSum = separation(acquiredAssetsSum);
            acquiredAssetsSumString.add(valueSum.toString());
    
            valuableAssetsSum = valuableAssetsSum + int.parse(valuableAssetsItems[index]);//評価資産
            presentvalueSUm = separation(valuableAssetsSum);
            valuableAssetsSumString.add(presentvalueSUm.toString());
    
            gain = separation(valuableAssetsSum - acquiredAssetsSum);
    
          });
         
          index++;
        }
    
    
        regExp = RegExp(r'icoUpGreen'); //new RegExp(r"/[0-9]+/");
        String signal = regExp.stringMatch(json).toString();
        if (signal == "null") {
          signalstate = false;
        } else {
          signalstate = true;
        }
        print("Signal : " + signal);
        print("hasMatch : " + regExp.hasMatch(json).toString());
        if ((regExp.hasMatch(json)) == false) {
          print("Green-Down"); //Down
        } else {
          print("Red-Up"); //Up
        }
      
    }
    


  



  



////////////////////////////////////////////////////

GridView gridView1() => new GridView.builder(
  scrollDirection: Axis.vertical,
  itemCount: widgets.length ,//+20,//<-- setState()
  gridDelegate:new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
  itemBuilder: (BuildContext context, int index) {
	return new GestureDetector(
	  child: new Card(
		  color: Colors.grey[850],
		  elevation: 5.0,
		  child: new Container(
		    child: Column(
			    crossAxisAlignment: CrossAxisAlignment.center,
			    mainAxisAlignment: MainAxisAlignment.center,
			    children: <Widget>[
			      new Text("(${widgets[index].code}) "+"${widgets[index].name}",
				      style: TextStyle(fontFamily: 'Roboto-Thin',fontSize: 10.0, color: Colors.white),),
			      new Text("現在値 ${separation(widgets[index].realValue)}",
				      style: TextStyle(fontFamily: 'Roboto',fontSize: 10.0, color: Colors.white),),
			      new Text("利益　${separation(widgets[index].gain)}",
				      style: TextStyle(fontFamily: 'Roboto',fontSize: 10.0,color: Colors.yellow),),
			      new Padding(
				      padding: new EdgeInsets.only(top: 15.0, right: 0.0, bottom: 0.0, left: 0.0),
				        child:SizedBox(
				          height: 15.0,
				          width: 60.0,  
				          child:RaisedButton(
					          padding: EdgeInsets.all(0.0),
					          disabledColor: Colors.orange,
					          shape: RoundedRectangleBorder(
					            borderRadius: BorderRadius.all(Radius.circular(2.0)),
					          ),
					          color: widgets[index].polar ? Colors.red : Colors.green,
					          child: new Text( widgets[index].percentcheng ? '${widgets[index].prevday}' : '${widgets[index].percent}',
									    style: TextStyle(fontSize: 10.0, color: Colors.black),),
					          onPressed: () => setState((){
					            widgets[index].percentcheng = !widgets[index].percentcheng;
					          }),
				          ),
				        ),
			        ),
			    ],
			  ),
			),
		),
	);
});





   Widget _buildTextComposer() {
	return new IconTheme(
	  data: new IconThemeData(color: Theme.of(context).accentColor),
	  child: new Container(
	   color: Colors.yellow,
	   margin: const EdgeInsets.symmetric(horizontal: 0.0),
		child: new Row(
		  children: <Widget>[
			new Flexible(
			  child: new TextField(
			  controller: _textController,
			  onChanged: (String text) {
				setState(() {
				  _isComposing = text.length > 0;
				});
			  },
			  onSubmitted: _handleSubmitted,
			  decoration:
					new InputDecoration.collapsed( hintText: "Input a Name123456789"),
			  ),
			),
			 new Flexible(
			  child: new TextField(
			 // controller: _textController,
			  onChanged: (String text) {
				setState(() {
				  _isComposing = text.length > 0;
				});
			  },
			  onSubmitted: _handleSubmitted,
			  decoration:
					new InputDecoration.collapsed( hintText: "Relut"),
			  ),
			),
			new Container(
			  margin: new EdgeInsets.symmetric(horizontal: 0.0),
			  child: new IconButton(
				icon: new Icon(Icons.search),
				onPressed: riseRate1,//_isComposing ? () => _handleSubmitted(_textController.text) : null,                                           //modified
			  ),
			),
		  ],
		),
	  ),
	);
  }



  void _handleSubmitted(String text) {
	  _textController.clear();
    setState(() {                                                  
	  // _messages.insert(0, message);                                
	  });                                                            
 }


  Widget base(){
    return new Column(
       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
       //mainAxisSize: MainAxisSize.max,
       //crossAxisAlignment: CrossAxisAlignment.stretch,
		 children: <Widget>[
      //Expanded(child:
        Column(children:[
					Column(children:[
            Container(
						  child:MaketStandard( stdwidgets : codeItems,),
						),
            Container(
              child:PortFolio(
						    portassetPrice : separation(assetTotalReturn()),
							  portassetTotal : separation(assetPriceReturn()),
							  portassetvalue:  separation(assetValueReturn()),
						  ),
						),
					],),
          Row(children:[  
                Expanded(child:
                  Container(
                  margin: EdgeInsets.only(left: 5.0),
                  //padding: EdgeInsets.all(1.0),
                  //height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.grey,
                  ),
                  child: TextField(
                    controller: codeCtrl,
                    decoration: InputDecoration(
                    labelText: 'CodeNumber',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        //height: 1,
                        fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                    errorText: _validateCode ? 'The CodeNumber input is empty.' : null,
                    contentPadding: const EdgeInsets.only(
                        left: 0.0, bottom: 15.0, top: 15.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellowAccent),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  autocorrect: false,
                  onSubmitted: (text) {
                    if (text.isEmpty) {
                      _validateCode = true;
                      setState(() {});
                    } else {
                      _validateCode = false;
                      codeItems.add(text);
                      codeCtrl.clear();
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                // height: 70.0,
                margin: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey,
                ),
                child: TextField(
                  controller: stockCtrl,
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        //height: 1,
                        fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                    errorText:
                        _validateStock ? 'The Stock input is empty.' : null,
                    contentPadding: const EdgeInsets.only(
                        left: 0.0, bottom: 15.0, top: 15.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  autocorrect: true,
                  onSubmitted: (text) {
                    if (text.isEmpty) {
                      _validateStock = true;
                      setState(() {});
                    } else {
                      _validateStock = false;
                      stockItems.add(text);
                      SharePrefs.setStockItems(stockItems).then((_) {
                        setState(() {});
                      });
                      stockCtrl.clear();
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                //height: 70.0,
                margin: EdgeInsets.only(left: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey,
                ),
                child: TextField(
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.bold),
                  controller: valueCtrl,
                  decoration: InputDecoration(
                    labelText: "value",
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        //height: 1,
                        fontWeight: FontWeight.bold),
                   errorText:
                        _validateValue ? 'The Value input is empty.' : null,
                    contentPadding: const EdgeInsets.only(
                        left: 0.0, bottom: 15.0, top: 15.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  autocorrect: true,
                  onSubmitted: (text) {
                    //TextFieldからの他のコールバック
                    if (text.isEmpty) {
                      _validateValue = true;
                      setState(() {});
                    } else {
                      _validateValue = false;
                      valueItems.add(text);
                      SharePrefs.setValueItems(valueItems).then((_) {
                        setState(() {});
                      });
                      valueCtrl.clear();
                    }
                  },
                ),
              ),
            ),
            InkWell(
                child: Icon(
                  Icons.add_circle,
                  color: Colors.blueAccent,
                  semanticLabel: "",
                ),
                onTap: () {
                  if (/*eCtrl.text.isEmpty ||*/ codeCtrl.text.isEmpty ||
                      stockCtrl.text.isEmpty ||
                      valueCtrl.text.isEmpty) {
                    //if (eCtrl.text.isEmpty) _validate = true;
                    if (codeCtrl.text.isEmpty) _validateCode = true;
                    if (stockCtrl.text.isEmpty) _validateStock = true;
                    if (valueCtrl.text.isEmpty) _validateValue = true;
                    setState(() {});
                  } else {
                    _validateCode = false;_validateStock = false;_validateValue = false;
                    codeItems.add(codeCtrl.text);
                    stockItems.add(stockCtrl.text);
                    valueItems.add(valueCtrl.text);
                    SharePrefs.setCodeItems(codeItems);
                    SharePrefs.setStockItems(stockItems);
                    SharePrefs.setValueItems(valueItems);
                    setState(() {
                      addfetch(codeCtrl.text);
                     
                    });
                            
                    codeCtrl.clear();stockCtrl.clear();valueCtrl.clear();
                  }
                }),
            Switch(
              value: _active,
              activeColor: Colors.orange,
              activeTrackColor: Colors.red,
              inactiveThumbColor: Colors.blue,
              inactiveTrackColor: Colors.green,
              onChanged: _changeSwitch,
            ),
              
          ],),
        ],),
        //),
        Expanded(child: 
				  Container(
            child:gridView1(),
					),
				),
              /*
              Container(child:
                Appreciation(stdwidgets : rategets),
							),
						  Container(child: 
                Volume(volumewidgets : volumegats,), 
              )
              */
      ],);
        
        
    
    
  }







  


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //appBar: AppBar(
        //title: Text('Fetch Data Example'),
        //),
        floatingActionButton: FloatingActionButton(
          mini: true,
          child: Icon(Icons.refresh),
          onPressed: () => setState(() => _reloadData()),// _addChip("code", "", "")),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _titleArea(),
              _titleArea1(),
              Expanded(
                flex: 5,
                child: _titleArealg(),
              ),
              //Expanded(
                //child: _buttonArea(),
              //),
            ],
          ),
        ),
        
      ),
    );
  }
}



/*
	new Stack(
	  alignment: new FractionalOffset(1.0, 0.0),
					  children: <Widget>[
						new FloatingActionButton(
						  elevation: 0.0,
						  child: new Icon(Icons.check),
						  backgroundColor: new Color(0xFFE57373),
						  onPressed: (){}
						)
					  ]
					),
*/
/*
class Finance{
		//public static async Task<List<Price>> Parse( )
		static List<Price> parse(var responce)
		{
			List<Price> prices = new List<Price>(); //ｺﾝｽﾄﾗｸﾀ
			//SaveLoadCS saveLoadCS = new SaveLoadCS();

			// UTF8のファイルの読み込み Edit.        
			//string response = await saveLoadCS.DataLoadAsync();//登録データ読み込み

			//dynamic rows = responce.replaceAll("\n,", "\n").split('\n');  //\r to delete & \n split 
			//dynamic rows = responce.replaceAll("\n,", "\n").split('\n');
			  var list = responce.split("\n"); 

			  //var listb =  list.length;        
			  //var list =responce;// ['apples, bananas, oranges'];
			  for( String row in list ) {
				if (row.isNotEmpty){
					//continue;
				  var lista = row.split(",");  
				  //Price p = new Price(lista[0],lista[1],lista[2],lista[3],lista[4],lista[5],list[6]);
				  Price p = new Price();
				  p.code = lista[0];//企業コード
				  p.stocks = (lista[1]);//保有数
				  p.itemprice = (lista[2]);//購入単価
				  prices.add(p);

				  print('Finance=${list.indexOf(row)}: $row');
				}
			  }
			return prices;
		}
	}
*/

/*
	class Price
	{
	  String code ;//会社名コード
	  String name;//会社名*
		String stocks;//保有数*
		String itemprice;//購入価格*
		double realprice;//現在値**
		String prevday;//前日比±**
		String percent; //前日比％**
		bool polar; //上げ下げ(+ or -)
		bool percentcheng;
		dynamic ayAssetprice;//保有数* 購入価格 = 投資総額
		int realValue;//利益総額
		String getrealValue;//NIkkei用
		//public decimal Ask { get; set; }//買値
		//Decimal Bid { get; set; }//売値/取引値
		dynamic investmen;//投資額
		dynamic investmens;//投資総額
		dynamic uptoAsset;//個別利益
		dynamic totalAsset;//現在評価額合計
		//public string  ButtonId { get; set; }
		//public string ButtonColor { get; set; }
		int gain;//損益
		//String FirstLastName { get { return Prev_day + "," + Percent; } }
		int idindex;

		//c# to {get; set;}
		 //Price(this.code, this.stocks, this.itemprice,this.name,this.realValue,this.prev_day,this.percent );
	}
*/

 








 





  
   