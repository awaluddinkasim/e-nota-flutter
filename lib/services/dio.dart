import 'package:dio/dio.dart';
import 'package:nota/constants.dart';

Dio dio({String? token}) {
  Dio dio = Dio();

  dio.options.baseUrl = AppConstants.baseApiUrl;
  dio.options.headers["Accept"] = "Application/json";
  if (token != null) {
    dio.options.headers["Authorization"] = "Bearer $token";
  }

  return dio;
}
