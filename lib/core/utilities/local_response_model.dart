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
      final hasStatus =
          response.first.keys.any((key) => key.toLowerCase() == 'status');
      return hasStatus && response.first.keys.length == 1;
    }
  }

  static String getErrorStatusFromResponse(Iterable response) {
    assert(response.isNotEmpty ||
        response.length == 1 ||
        response.first.keys.length == 1);
    try {
      final key = response.first.keys.firstWhere(
          (k) => k.toLowerCase() == 'status',
          orElse: () => throw Exception('An unexpected error occured.'));
      return response.first[key as String];
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
