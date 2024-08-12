import 'dart:convert';

import 'package:coinapp/main.dart';
import 'package:coinapp/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});





  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {

    double? _deviceHieght, _deviceWidth;

    HTTPServices? _http;

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _http = locator.get<HTTPServices>();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
          
            child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
            children: [
              selectedCoinDropDown(),
            
              Image.asset("images/bitcoin.png",width: 65,),
            
              dataContainer(),
                  ],
                  ),
          ),
        ),

      ),
    );
  }

   Widget selectedCoinDropDown (){
        List<String> _coins=['Bitcoin','PyCoin'];
    List<DropdownMenuItem<String>> _items = _coins
        .map(
          (e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: const TextStyle(
                    fontSize: 34,
                    color: Colors.white),
              )),
        )
        .toList();
        
        return DropdownButton(
      value: _coins.first,
      items: _items,
      onChanged: (_value) {},
      dropdownColor: const Color.fromARGB(255, 107, 107, 107),
      icon: const Icon(
        Icons.arrow_downward_sharp,
        color: Colors.white,
      ),
    
        );

      }

      Widget dataContainer() {
        return FutureBuilder(
          future: _http!.get("/coins/bitcoin"),
         builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
          Map _data = jsonDecode(
            snapshot.data.toString(),
          );
          int _usdPrice = _data["market_data"]["current_price"]["usd"];
          double _changePercntage = _data["market_data"]["price_change_percentage_24h_in_currency"]["usd"];
          String _discription =  _data["description"]["en"];

          // return _currentPrice (_usdPrice);
          return Column(
              
                children: [
                _currentPrice (_usdPrice),
                _changePercentage (_changePercntage),
                _coinDiscription (_discription),
              ],
            
            );
          }
          else{
            return const Center(child: CircularProgressIndicator());
            
          }
        },
        );
        
      }

      Widget _currentPrice (num _rate){
        return Text("\$ " + _rate.toStringAsFixed(2),
        style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.white,),);
      }

      Widget _changePercentage (double _rate){
        return Text(_rate.toStringAsFixed(5) + " %",
        style: TextStyle(fontSize: 14,color: Color.fromARGB(255, 224, 224, 224),),);
      }

      Widget _coinDiscription (String _discription){
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: EdgeInsets.all(15),
            color: Color.fromARGB(255, 80, 80, 80),
            child: Text(_discription,
            style: TextStyle(fontSize: 14,color: Color.fromARGB(255, 224, 224, 224),),),
          ),
        );
      }

}