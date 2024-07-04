import 'package:namer_app/core/enums/request_method.dart';
import 'package:namer_app/services/reply_handler.dart';

const String baseUrl = String.fromEnvironment(
  'http://183.83.33.156:85/api/', //base url should go here
  defaultValue: 'http://183.83.33.156:85/api/',
);

abstract class ApiConfig {
  String path;
  RequestMethod method;
  bool isAuth;
  String module;

  ApiConfig({
    required this.path,
    required this.method,
    this.isAuth = true,
    required this.module,
  });

  // to generate full URL
  String getUrlString({String? urlParam}) {
    return '$baseUrl$module$path${urlParam ?? ""}';
  }

  /// redirection
  Future<ResponseBody> sendRequest(
      {String? urlParam, RequestBody? body, ApiHeaderType? headersCustom}) {
    return RequestHandler.call(getUrlString(urlParam: urlParam), method,
        authorized: isAuth, body: body, headersCustom: headersCustom);
  }
}
