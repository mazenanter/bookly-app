import 'package:dio/dio.dart';

abstract class Failure {
  final String errMsg;

  Failure(this.errMsg);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMsg);

  factory ServerFailure.fromDioErr(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with api sever');
      case DioExceptionType.sendTimeout:
        return ServerFailure('send timeout with api sever');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive Timeout  with api sever');
      case DioExceptionType.cancel:
        return ServerFailure('Request Canceled , please try again');
      case DioExceptionType.unknown:
        if (e.message!.contains('SocketException')) {
          return ServerFailure('No Internet Connection , please try again');
        }
        return ServerFailure('Unexpected Error, Please try again');
      case DioExceptionType.badCertificate:
        return ServerFailure('badCertificate with api server');
      case DioExceptionType.connectionError:
        return ServerFailure('No Internet Connection');
      case DioExceptionType.badResponse:
        return ServerFailure.fromRespone(
            e.response!.statusCode!, e.response!.data);

      default:
        return ServerFailure('Oops There was an Error, Please try again');
    }
  }
  factory ServerFailure.fromRespone(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(response['error']['message']);
    } else if (statusCode == 404) {
      return ServerFailure('Your requese not found,please try again later!');
    } else if (statusCode == 500) {
      return ServerFailure('Internel Server Error,please try again later!');
    } else {
      return ServerFailure('Oops There was an Error, Please try again');
    }
  }
}
