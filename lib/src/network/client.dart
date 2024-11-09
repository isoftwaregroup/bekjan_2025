import 'package:app/src/variables/language.dart';
import 'package:app/src/variables/links.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'http_result.dart';

DioClient? _client;
DioClient get client {
  _client ??= DioClient();
  return _client!;
}

class DioClient {
  Dio? _dio;
  Dio get dio {
    if (_dio == null) {
      _dio = Dio();
      _dio!
        ..interceptors.add(PrettyDioLogger(
          requestHeader: kDebugMode,
          requestBody: kDebugMode,
          responseBody: kDebugMode,
          responseHeader: false,
          error: kDebugMode,
          canShowLog: kDebugMode,
          showCUrl: kDebugMode,
        ))
        ..options.baseUrl = Links.baseUrl
        ..options.connectTimeout = const Duration(seconds: 30)
        ..options.receiveTimeout = const Duration(seconds: 30)
        ..httpClientAdapter
        ..options.headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };
    }
    return _dio!;
  }

  Future<MainModel> get(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool withoutHeader = false,
  }) async {
    try {
      final response = await dio.get(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: withoutHeader ? {} : await _header()),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return _analizeResponse(response);
    } catch (e) {
      print('dioError: $e');
      if (e is DioException) {
        return _analizeResponse(e.response);
      }
      return defaultModel;
    }
  }

  Future<MainModel> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: await _header()),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _analizeResponse(response);
    } catch (e) {
      print('dioError: $e');
      if (e is DioException) {
        return _analizeResponse(e.response);
      }
      return defaultModel;
    }
  }

  MainModel _analizeResponse(Response? response) {
    if (response != null) {
      if (response.data == null) {
        return defaultModel.copyWith(
          status: response.statusCode,
          message: response.statusMessage,
        );
      }
      if (response.data['status'] == 'OK') {
        return MainModel(
          status: 200,
          message: '',
          data: response.data['predictions'] ?? response.data['results'],
        );
      }
      if (response.data['status'] == null) {
        return MainModel(
          status: 200,
          message: '',
          data: response.data,
        );
      }
      MainModel mainmodel = MainModel.fromJson(response.data);
      if (mainmodel.status == 200 ||
          mainmodel.status == 500 ||
          mainmodel.status == 401) {
        return mainmodel;
      }
      return mainmodel.copyWith(
        message: checkKeys(mainmodel.error),
      );
    }
    return defaultModel;
  }

  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: await _header()),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      var response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: await _header()),
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> _header() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";
    String lan = prefs.getString("language") ?? "uz";
    if (token == "") {
      return {
        "Accept-Language": lan,
      };
    } else {
      return {
        "Authorization": "Bearer $token",
        "Accept-Language": lan,
      };
    }
  }

  String checkKeys(Map<String, dynamic> data) {
    if (data.values.isEmpty) {
      return error.tr;
    }
    try {
      for (var i = 0;
          i < (data.values.length > 20 ? 20 : data.values.length);
          i++) {
        final value = data.values.elementAt(i);
        if (value is List) {
          if (value.isNotEmpty) {
            return value.first.toString();
          }
        } else if (value is String) {
          return value;
        }
      }
      return error.tr;
    } catch (e) {
      return error.tr;
    }
  }
}
