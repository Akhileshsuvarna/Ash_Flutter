import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../models/DataState.dart';
import '../models/chat_model.dart';

class HttpProvider {
  static Future postMessage(
      {required String sender, required String message}) async {
    try {
      Uri url = Uri.parse(('http://159.89.166.172:5005/webhooks/rest/webhook'));
      return await post(url,
          body: jsonEncode({"sender": sender, "message": message}),
          headers: {
            "Content-type": "application/json",
            // "Authorization": token,
          });

    } on HttpException catch (e) {
      print('Http Exp1ð: ${e.runtimeType}');
    } catch (e) {
      print('error${e}');
      return e.toString();
    }
  }
}
