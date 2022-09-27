import 'package:health_connector/log/logger.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

abstract class IWebServices {
  Map<String, String> getHeader({bool? tokenBearer});
  Future<http.Response> get(String path, {List<String>? parameters});
  Future<http.Response> post(String url, dynamic body, {String? path});
  Future<http.Response> put(String path, dynamic body);
  Future<http.Response> delete(String path, dynamic body);
}

class WebServices extends IWebServices {
  late final String _baseUrl;

  WebServices(String baseUrl) {
    _baseUrl = baseUrl;
  }

  @override
  Map<String, String> getHeader({bool? tokenBearer}) {
    if (tokenBearer == null) {
      return {'Content-Type': 'application/json'};
    } else {
      var _bearerToken = prefs.getString("token"); // Add bearer token here
      return {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': 'true',
        'Authorization': 'Bearer $_bearerToken',
      };
    }
  }

  @override
  Future<http.Response> get(String path, {List<String>? parameters}) async {
    try {
      var uri = Uri(
          scheme: 'https',
          host: _baseUrl,
          path: path,
          pathSegments: parameters);
      http.Response result = await http.get(uri, headers: getHeader());
      //var jsondata = json.decode(result.body);
      return result;
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
      throw 'Exception $e';
    }
  }

  @override
  Future<http.Response> post(String url, dynamic body, {String? path}) async {
    try {
      http.Response result = await http.post(Uri(host: _baseUrl, path: path),
          headers: getHeader(), body: body);
      //var jsondata = json.decode(result.body);
      return result;
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
      throw 'Exception $e';
    }
  }

  @override
  Future<http.Response> put(String path, dynamic body) async {
    try {
      http.Response result = await http.put(Uri(host: _baseUrl, path: path),
          headers: getHeader(), body: body);
      //var jsondata = json.decode(result.body);
      return result;
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
      throw 'Exception $e';
    }
  }

  @override
  Future<http.Response> delete(String path, dynamic body) async {
    try {
      http.Response result = await http.delete(Uri(host: _baseUrl, path: path),
          headers: getHeader(), body: body);
      //var jsondata = json.decode(result.body);
      return result;
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
      throw 'Exception $e';
    }
  }
}
