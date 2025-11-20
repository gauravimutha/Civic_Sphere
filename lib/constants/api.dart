import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static const String basicurl = "https://civicsphere.pythonanywhere.com/"
      //'http://127.0.0.1:8000/'
      ;
  static const String register = '${basicurl}auth/register/';
  static const String login = '${basicurl}auth/login/';
  static const String profile = '${basicurl}user/profile/';
  static const String newlisting = '${basicurl}jobs/create/';
  static const String jobs = '${basicurl}jobs/';
  static const String userearnings = '${basicurl}workers/';
  static const String customerReviews = '${basicurl}reviews/customer/';
  static const String workerjob = '${basicurl}jobs/open/';
  static String deleteJob(int jobId) => '${basicurl}jobs/$jobId/delete/';
  static String updateJob(int jobId) => '${basicurl}5/$jobId/update/';
  static String acceptoffer(int jobId) => '${basicurl}jobs/$jobId/accept/';
  static String offer(int jobId) => '${basicurl}jobs/$jobId/offers/';

  final Dio _dio = Dio();
  String? _cachedToken;

  Future<void> storeToken(String accessToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', accessToken);
    _cachedToken = accessToken;
  }

  Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString('token');
    return _cachedToken;
  }

  Future<Response?> postData(String url, Map<String, dynamic> data,
      {bool useAuth = true}) async {
    try {
      Map<String, String> headers = {'Content-Type': 'application/json'};

      if (useAuth) {
        String? token = await getToken();
        if (token == null) {
          print("No token found for request: $url");
          return null;
        }
        headers['Authorization'] = 'Bearer $token';
      }

      Response response = await _dio.post(
        url,
        data: jsonEncode(data),
        options: Options(headers: headers),
      );

      return response;
    } on DioException catch (e) {
      print('Error: ${e.message}');
    }
    return null;
  }

  Future<Response?> getData(
    String url, {
    bool useAuth = true,
  }) async {
    try {
      final headers = {'Content-Type': 'application/json'};

      if (useAuth) {
        final token = await getToken();
        if (token == null) {
          print("No token found for request: $url");
          return null;
        }
        headers['Authorization'] = 'Bearer $token';
      }

      return await _dio.get(
        url,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      print('Error: ${e.message}');
    }
    return null;
  }
}
