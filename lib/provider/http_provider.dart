import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/constant.dart';

class HttpProvider {
  Future<dynamic> postHttp(String path, data) async {
    // Dio().options.headers['content-Type'] = 'application/json';
    // Dio().options.contentType = 'application/json';
    Duration? fivemin = const Duration(seconds: 5);
    Duration? treemin = const Duration(seconds: 3);

    Dio().options.connectTimeout = fivemin; //5s
    Dio().options.receiveTimeout = treemin;
    Dio().options.contentType = Headers.formUrlEncodedContentType;
    BaseOptions(
        connectTimeout: fivemin, receiveTimeout: treemin, baseUrl: path);
    // var response = await Dio().post(
    //   'http://192.168.1.140:8080/api/$path',
    //   data: data,
    //   options: Options(contentType: Headers.formUrlEncodedContentType),
    // );
    var response = await Dio().post(api + path, data: data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response);
      return response.data;
    } else {
      print(response);
      throw Exception([response.statusCode, response.data]);
    }
  }

  Future<dynamic> getHttp(String path) async {
    Duration? fivemin = const Duration(seconds: 5);
    Duration? treemin = const Duration(seconds: 3);

    print("path${api}${path}");

    Dio().options.headers['content-Type'] = 'application/json';
    Dio().options.contentType = 'application/json';
    Dio().options.connectTimeout = fivemin; //5s
    Dio().options.receiveTimeout = treemin;
    BaseOptions(
        connectTimeout: fivemin, receiveTimeout: treemin, baseUrl: path);
    // var response = await Dio().get('http://192.168.1.140:8080/api/$path');
    var response = await Dio().get(api + path);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response);
      return response.data;
    } else {
      print(response);
      throw Exception([response.statusCode, response.data]);
    }
  }

  Future<dynamic> getHttp2(String path) async {
    Duration? fivemin = const Duration(seconds: 5);
    Duration? treemin = const Duration(seconds: 3);

    Dio().options.headers['content-Type'] = 'application/json';
    Dio().options.contentType = 'application/json';
    Dio().options.connectTimeout = fivemin; //5s
    Dio().options.receiveTimeout = treemin;
    BaseOptions(
        connectTimeout: fivemin, receiveTimeout: treemin, baseUrl: path);
    // var response = await Dio().get('http://192.168.1.140:8080/api/$path');
    var response = await Dio().get(api2 + path);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response);
      return response.data;
    } else {
      print(response);
      throw Exception([response.statusCode, response.data]);
    }
  }

  Future<dynamic> getHttp3(String path) async {
    Duration? fivemin = const Duration(seconds: 5);
    Duration? treemin = const Duration(seconds: 3);

    Dio().options.headers['content-Type'] = 'application/json';
    Dio().options.contentType = 'application/json';
    Dio().options.connectTimeout = fivemin; //5s
    Dio().options.receiveTimeout = treemin;
    BaseOptions(
        connectTimeout: fivemin, receiveTimeout: treemin, baseUrl: path);
    // var response = await Dio().get('http://192.168.1.140:8080/api/$path');
    var response = await Dio().get(api3 + path);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception([response.statusCode, response.data]);
    }
  }

  Future<dynamic> postHttp2(String path, data) async {
    Duration? fivemin = const Duration(seconds: 5);
    Duration? treemin = const Duration(seconds: 3);

    // Dio().options.headers['content-Type'] = 'application/json';
    // Dio().options.contentType = 'application/json';
    Dio().options.connectTimeout = fivemin; //5s
    Dio().options.receiveTimeout = treemin;
    Dio().options.contentType = Headers.formUrlEncodedContentType;
    BaseOptions(
        connectTimeout: fivemin, receiveTimeout: treemin, baseUrl: path);

    // var response = await Dio().post(
    //   'http://192.168.1.140:8080/api/$path',
    //   data: data,
    //   options: Options(contentType: Headers.formUrlEncodedContentType),
    // );
    var response = await Dio().post(api2 + path, data: data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response);
      return response.data;
    } else {
      print("Internet not found");
      print(response);
      throw Exception([response.statusCode, response.data]);
    }
  }

  Future<dynamic> postHttp3(String path, data) async {
    Duration? fivemin = const Duration(seconds: 5);
    Duration? treemin = const Duration(seconds: 3);

    // Dio().options.headers['content-Type'] = 'application/json';
    // Dio().options.contentType = 'application/json';
    Dio().options.connectTimeout = fivemin; //5s
    Dio().options.receiveTimeout = treemin;
    Dio().options.contentType = Headers.formUrlEncodedContentType;
    BaseOptions(
        connectTimeout: fivemin, receiveTimeout: treemin, baseUrl: path);
    // var response = await Dio().post(
    //   'http://192.168.1.140:8080/api/$path',
    //   data: data,
    //   options: Options(contentType: Headers.formUrlEncodedContentType),
    // );
    var response = await Dio().post(api3 + path, data: data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception([response.statusCode, response.data]);
    }
  }

  Future<dynamic> postHttp4(String path, data) async {
    Duration? fivemin = const Duration(seconds: 5);
    Duration? treemin = const Duration(seconds: 3);

    // Dio().options.headers['content-Type'] = 'application/json';
    // Dio().options.contentType = 'application/json';
    Dio().options.connectTimeout = fivemin; //5s
    Dio().options.receiveTimeout = treemin;
    Dio().options.contentType = Headers.formUrlEncodedContentType;
    BaseOptions(
        connectTimeout: fivemin, receiveTimeout: treemin, baseUrl: path);
    // var response = await Dio().post(
    //   'http://192.168.1.140:8080/api/$path',
    //   data: data,
    //   options: Options(contentType: Headers.formUrlEncodedContentType),
    // );
    var response = await Dio().post(apiTest + path, data: data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception([response.statusCode, response.data]);
    }
  }

  Future<dynamic> getHttp4(String path) async {
    Duration? fivemin = const Duration(seconds: 5);
    Duration? treemin = const Duration(seconds: 3);

    Dio().options.headers['content-Type'] = 'application/json';
    Dio().options.contentType = 'application/json';
    Dio().options.connectTimeout = fivemin; //5s
    Dio().options.receiveTimeout = treemin;
    BaseOptions(
        connectTimeout: fivemin, receiveTimeout: treemin, baseUrl: path);
    // var response = await Dio().get('http://192.168.1.140:8080/api/$path');
    var response = await Dio().get(apiTest + path);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception([response.statusCode, response.data]);
    }
  }

  Future<String?> getClientId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientId = prefs.getString('clientId');
    return clientId;
  }
}
