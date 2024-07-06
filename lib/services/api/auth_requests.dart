import 'package:namer_app/core/enums/request_method.dart';
import 'package:namer_app/core/utilities/api_config.dart';

class StudentDetailsApi extends ApiConfig {
  StudentDetailsApi(
      {super.module = 'SchoolDetails',
      required super.path,
      required super.method,
      super.isAuth = false});

  static final getSDetails =
      StudentDetailsApi(path: '/GetSDetails', method: RequestMethod.post);

  static final getFacilities =
      StudentDetailsApi(path: '/GetFacilities', method: RequestMethod.post);

  static final parentReg =
      StudentDetailsApi(path: '/ParentReg', method: RequestMethod.post);

  static final addStudent =
      StudentDetailsApi(path: '/AddStudent', method: RequestMethod.post);
}
