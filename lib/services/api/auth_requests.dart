import 'package:namer_app/core/enums/request_method.dart';
import 'package:namer_app/core/utilities/api_config.dart';

class SchoolDetailsApi extends ApiConfig {
  SchoolDetailsApi(
      {super.module = 'SchoolDetails',
      required super.path,
      required super.method,
      super.isAuth = false});

  static final getSDetails =
      SchoolDetailsApi(path: '/GetSDetails', method: RequestMethod.post);

  static final getFacilities =
      SchoolDetailsApi(path: '/GetFacilities', method: RequestMethod.post);

  static final parentReg =
      SchoolDetailsApi(path: '/ParentReg', method: RequestMethod.post);

  static final addStudent =
      SchoolDetailsApi(path: '/AddStudent', method: RequestMethod.post);

  static final getParentDet =
      SchoolDetailsApi(path: '/GetParentDet', method: RequestMethod.post);
}
