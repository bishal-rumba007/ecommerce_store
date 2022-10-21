import 'package:dio/dio.dart';

class DioException {

  String  getDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.response:
        return _handleStatusCode(dioError.response?.statusCode);
      case DioErrorType.other:
        if (dioError.message.contains('SocketException')) {
          return 'No Internet.';
        }else{
          return 'Unexpected error occurred.';
        }
      default:
        return  'Something went wrong';

    }
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request.';
      case 401:
        return 'Authentication failed.';
      case 404:
        return 'The requested resource does not exist.';
      case 405:
        return 'Method not allowed. Please check the Allow header for the allowed HTTP methods.';
      case 422:
        return 'Data validation failed.';
      case 429:
        return 'Too many requests.';
      case 500:
        return 'Internal server error.';
      default:
        return 'Oops something went wrong!';
    }
  }


}