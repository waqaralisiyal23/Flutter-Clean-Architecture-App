import 'dart:io' show HttpStatus;

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../utils/resources/data_state.dart';

abstract class BaseApiRepository {
  /// This method is responsible of handling the given `request`, in which
  /// it returns generic based `DataState`.
  ///
  /// Returns `DataSuccess` that holds the generic data `T` if the response
  /// is successfully recieved.
  ///
  /// Returns `DataFailed` that holds a `DioError` instance if any error occurs
  /// while sending the request or recieving the response.
  Future<DataState<T>> getStateOf<T>({
    required Future<HttpResponse<T>> Function() request,
  }) async {
    try {
      final httpResponse = await request();
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(data: httpResponse.data!);
      } else {
        throw DioError(
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
        );
      }
    } on DioError catch (error) {
      return DataFailed(error: error);
    }
  }
}
