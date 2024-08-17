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
    String? valueChoose;
    String? assetImage='bitcoin.png';

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _http = locator.get<HTTPServices>();
    valueChoose=_coins.first;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
          
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
            children: [
              selectedCoinDropDown(),
              SizedBox(height: 25,),

            
              Image.asset("images/$assetImage",width: 65,),
              SizedBox(height: 25,),
              DataContainer(),
            
                  ],
                  ),
          ),
        ),

      ),
    );
  }

 String? mainURL='/coins/bitcoin';
  Map<String, dynamic>? _data;
  
  void isChangedFunction(String newValue){
   if(newValue=='Ethereum'){
            mainURL="/coins/ethereum";
            assetImage='ethereum.png';
          }
    else if(newValue=='Bitcoin'){
            mainURL="/coins/bitcoin";
            assetImage='bitcoin.png';
          }
print("Selected Value is: $newValue");
// DataContainer(mainURL!);

  }

     List<String> _coins=['Bitcoin','Ethereum'];
       
  // String? valueItem;



Widget selectedCoinDropDown (){

    // List<DropdownMenuItem<String>> _items = _coins
    //     .map(
    //       (e) => DropdownMenuItem(
    //           value: e,
    //           child: Text(
    //             e,
    //             style: const TextStyle(
    //                 fontSize: 34,
    //                 color: Colors.white),
    //           )),
    //     )
    //     .toList();

    
        
        return DropdownButton(
      value: valueChoose,
      onChanged: (_value) {
        setState(() {
          valueChoose = _value;
          isChangedFunction(_value!);
          
        });
        
      },

      items:_coins.map((e) {
        return DropdownMenuItem(
          value: e,
          child: Text(e,
          style: const TextStyle(
                    fontSize: 34,
                    color: Colors.white),),
        );
      },).toList(),
      
      dropdownColor: Color.fromARGB(255, 0, 0, 0),
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
    
        );

      }

       Widget DataContainer() {
        return FutureBuilder(
          future: _http!.get(mainURL!),
         builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
           _data = jsonDecode(
            snapshot.data.toString(),
          );
          var _usdPrice = _data!["market_data"]["current_price"]["usd"];
          var _changePercntage = _data!["market_data"]["price_change_percentage_24h_in_currency"]["usd"];
          String _discription =  _data!["description"]["en"];

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

      Widget _currentPrice (var _rate){
        return Text("\$ " + _rate.toStringAsFixed(2),
        style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.white,),);
      }

      Widget _changePercentage (var _rate){
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