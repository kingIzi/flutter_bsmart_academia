//import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:namer_app/core/enums/request_method.dart';
import 'package:namer_app/core/utilities/local_response_model.dart';

// const String baseUrl = String.fromEnvironment(
//   'http://183.83.33.156:85/api/', //base url should go here
//   defaultValue: 'http://183.83.33.156:85/api/',
// );

///Request Body
typedef RequestBody = Map<String, dynamic>;

///Response Body
typedef ResponseBody = Map<String, dynamic>; //Iterable;

/// Api Header
typedef ApiHeaderType = Map<String, String>;

class RequestHandler {
  static Future<ResponseBody> call(String urlString, RequestMethod method,
      {bool authorized = true,
      RequestBody? body,
      ApiHeaderType? headersCustom}) async {
    try {
      Map<String, String> headers = headersCustom ??
          {
            'Content-Type': 'application/json',
            if (authorized)
              HttpHeaders.authorizationHeader:
                  'TOKEN GOES HERE' //Helpers.getToken(),
          };

      /// Api call
      final Response response = await method
          .apiCall(Uri.parse(urlString),
              headers: headers, body: json.encode(body))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException(
                'Your request took too long. Please verify your connection or try again.'),
          );

      if (response.statusCode != 200) {
        throw 'An unexpected Error has occured on the server. Contact support or try again.';
      }

      final responseBody = json.decode(response.body);
      return LocalResponseModel.successResponse(response: responseBody).toMap();
    } on TimeoutException catch (e) {
      return LocalResponseModel.errorResponse(message: e.message).toMap();
    } on SocketException catch (e) {
      return LocalResponseModel.errorResponse(
              message: 'Failed. Please verify your connection or try again.')
          .toMap();
    } catch (e) {
      return LocalResponseModel.errorResponse(message: e.toString()).toMap();
    }
  }
}
