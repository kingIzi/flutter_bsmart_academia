import 'package:namer_app/core/enums/request_method.dart';
import 'package:namer_app/core/utilities/api_config.dart';

class LoginUser extends ApiConfig {
  LoginUser(
      {super.module = 'SchoolDetails',
      required super.path,
      required super.method,
      super.isAuth = false});

  static final getSDetails =
      LoginUser(path: '/GetSDetails', method: RequestMethod.post);
}
