import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:currency_converter_demo/services/api_client.dart';
import 'package:currency_converter_demo/widget/Drop_Down_Item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Currency Converter',
        debugShowCheckedModeBanner: false,
        home: Homepage(),
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController controller=TextEditingController(); //to store the text which is given by user
  bool hasInternet=false;    //a variable to store bool value by depend on internet connectivity


  Color mainColor = Color(0xFF212936);
  Color secondColor = Color(0xFF2849E5);
  List<String> currencies=[];
  late String from='';
  late String to='';

  late double rate;
  String result='';

  Api_client client=Api_client();

  Future<List<String>> getCurrencyList() async{
    return await client.getCurrensies();
  }


  // final Uri currency_api=Uri.https("free.currconv.com","/api/v7/currencies", {"apiKey":"0a887d855a68b6afb8a6"});
  // // final response=await http.get(Uri.parse("https://jsonplaceholder.typicode.com/comments"));
  // //   final response= await http.get(Uri.parse('https://free.currconv.com/api/v7/currencies?apiKey=0a887d855a68b6afb8a6'));
  // Future<List<String>> getCurrensies() async{
  //   final response= await http.get(currency_api);
  //   if(response.statusCode==200){
  //     var body=jsonDecode(response.body);
  //     var list=body['results'];
  //     List<String> currensies=(list.keys).toList();
  //     print(currensies);
  //     return currensies;
  //   }
  //   else{
  //     throw Exception('Failed to connect to API.');
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    (() async{
      List<String> list=await getCurrencyList();
      setState(() {
        currencies= list;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: RefreshIndicator(
        onRefresh: getCurrencyList,
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                  child: Text(
                'Currency Converter',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              ),
              Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextField(
                          controller: controller,
                          onSubmitted: (value)async{
                            hasInternet=await InternetConnectionChecker().hasConnection;

                            if(hasInternet==true){
                            rate=await client.getRate(from, to);
                            setState(() {
                              if(controller.text.toString().isEmpty){
                                result='0.0';
                                Fluttertoast.showToast(
                                    msg: 'Input value is Empty!!',
                                   backgroundColor: secondColor,
                                  textColor: Colors.white,

                                );
                              }
                              else {
                                result=(rate*double.parse(controller.text.toString())).toStringAsFixed(3);
                              }
                            });
                            }
                            else{  //if no internet then i show a notification
                              showSimpleNotification(
                                Text('No Internet Connection!'),
                                background: Colors.red,
                              );
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Input value to convert',
                            filled: true,
                            fillColor: Colors.white,
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: secondColor,
                              fontSize: 18,
                            )
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomDropDown(currencies, from, (val){
                              if(hasInternet==true){
                                setState(() async{
                                  from=val;
                                  rate=await client.getRate(from, to);
                                  setState(() {
                                    if(controller.text.toString().isEmpty){
                                      result='0.0';
                                      Fluttertoast.showToast(
                                        msg: 'Input value is Empty!!',
                                        backgroundColor: secondColor,
                                        textColor: Colors.white,
                                      );
                                    }
                                    else {
                                      result=(rate*double.parse(controller.text.toString())).toStringAsFixed(3);
                                    }
                                  });
                                });
                              }
                              else{  //if no internet then i show a notification
                                showSimpleNotification(
                                  Text('No Internet Connection!'),
                                  background: Colors.red,
                                );
                              }
                            }),
                            FloatingActionButton(
                                onPressed: (){
                                  if(hasInternet==true){
                                    String temp=from;
                                    setState(() async{
                                      from=to;
                                      to=temp;
                                      rate=await client.getRate(from, to);
                                      setState(() {
                                        if(controller.text.toString().isEmpty){
                                          result='0.0';
                                          Fluttertoast.showToast(
                                            msg: 'Input value is Empty!!',
                                            backgroundColor: secondColor,
                                            textColor: Colors.white,

                                          );
                                        }
                                        else {
                                          result=(rate*double.parse(controller.text.toString())).toStringAsFixed(3);
                                        }
                                      });
                                    });
                                  }
                                  else{  //if no internet then i show a notification
                                    showSimpleNotification(
                                      Text('No Internet Connection!'),
                                      background: Colors.red,
                                    );
                                  }
                                },
                              child: Icon(Icons.swap_horiz),
                              elevation: 0,
                              backgroundColor: secondColor,
                            ),
                            CustomDropDown(currencies, to, (val){
                              if(hasInternet==true){
                                setState(() async{
                                  to=val;
                                  rate=await client.getRate(from, to);
                                  setState(() {
                                    if(controller.text.toString().isEmpty){
                                      result='0.0';
                                      Fluttertoast.showToast(
                                        msg: 'Input value is Empty!!',
                                        backgroundColor: secondColor,
                                        textColor: Colors.white,

                                      );
                                    }
                                    else {
                                      result=(rate*double.parse(controller.text.toString())).toStringAsFixed(3);
                                    }

                                  });
                                });
                              }
                              else{         //if no internet then i show a notification
                                showSimpleNotification(
                                  Text('No Internet Connection!'),
                                  background: Colors.red,
                                );
                              }
                            }),
                          ],
                        ),
                        SizedBox(height: 50),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text('Result',style: TextStyle(fontSize: 24,color: Colors.black,fontWeight: FontWeight.bold),),
                              SizedBox(height: 5,),
                              Text(result,style: TextStyle(color: secondColor,fontSize: 36,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            ],
          ),
        )),
      ),
    );
  }
}


/*
FutureBuilder(
                            future: getCurrensies(),
                            builder: (context,AsyncSnapshot<List<String>> snapshot){
                              if(snapshot.hasData){
                                return CustomDropDown(currencies, from, (val){});
                              }
                              else if(snapshot.hasError){
                                return Center(child: Text("${snapshot.error}"));
                              }
                              else{
                                return Center(child: CircularProgressIndicator());
                              }
                            },
                          )
 */