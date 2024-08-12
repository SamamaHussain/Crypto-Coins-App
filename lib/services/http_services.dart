import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../models/app_config.dart';


class HTTPServices {
  Dio dio=Dio();

  appConfig? _appConfig;
  String? _baseApiURL;

  HTTPServices() {
    _appConfig = GetIt.instance.get<appConfig>();
    _baseApiURL= _appConfig!.COIN_API_BASE_URL;

  }

  Future<Response?> get (String path) async{
    try{
      String _url="$_baseApiURL$path";
    Response _response = await dio.get(_url);
    return _response; 
    }
    catch(e){
      print('HTTPServices: Unable to get Response from the URL');
      print(e);
    }
  }
}