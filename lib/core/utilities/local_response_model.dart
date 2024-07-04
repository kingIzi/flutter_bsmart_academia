class LocalResponseModel {
  String? message;
  Iterable? response;
  String? statusCode;

  LocalResponseModel({
    this.message,
    this.response,
    this.statusCode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'response': response,
      'statusCode': statusCode,
    };
  }

  static LocalResponseModel errorResponse({
    String? message,
    Iterable? response,
    String? statusCode,
  }) {
    return LocalResponseModel(
      message: message ?? 'An Error has occured on the server.',
      response: response,
      statusCode: statusCode ?? '500',
    );
  }

  static LocalResponseModel successResponse(
      {String? message, Iterable? response, String? statusCode}) {
    return LocalResponseModel(
        message: message ?? 'success',
        response: response ?? [],
        statusCode: statusCode ?? '200');
  }

  static bool hasErrorResponse(Iterable response) {
    if (response.isEmpty || response.length > 1) {
      return false;
    } else {
      var item = response.first;
      var hasStatus = item.keys.any((key) => key.toLowerCase() == 'status');
      return hasStatus && item.keys.length == 1;
    }
  }

  static String getErrorStatusFromResponse(Iterable response) {
    assert(response.isNotEmpty || response.length == 1);
    return response.first['status'];
  }
}
