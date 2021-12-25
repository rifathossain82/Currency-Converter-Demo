import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api_client{
  final Uri currency_api=Uri.https("free.currconv.com","/api/v7/currencies", {"apiKey":"0a887d855a68b6afb8a6"});
 // final response=await http.get(Uri.parse("https://jsonplaceholder.typicode.com/comments"));
 //   final response= await http.get(Uri.parse('https://free.currconv.com/api/v7/currencies?apiKey=0a887d855a68b6afb8a6'));
  Future<List<String>> getCurrensies() async{
   final response= await http.get(currency_api);
    if(response.statusCode==200){
      var body=jsonDecode(response.body);
      var list=body['results'];
      List<String> currensies=(list.keys).toList();
      return currensies;
    }
    else{
      throw Exception('Failed to connect to API.');
    }
  }


  Future<double> getRate(String from, String to) async{
    final Uri rate_uri=Uri.https("free.currconv.com","/api/v7/convert",
        {"apiKey":"0a887d855a68b6afb8a6",
          "q":"${from}_${to}",
          "compact": "ultra"
        },
    );
    final response= await http.get(rate_uri);
    if(response.statusCode==200){
      var body=jsonDecode(response.body);
      return body["${from}_${to}"];
    }
    else{
      throw Exception('Failed to connect to API.');
    }
  }
}