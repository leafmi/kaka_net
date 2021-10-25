import 'package:dio/dio.dart';
import 'package:kaka_net/src/core/kaka_net_response.dart';
import 'package:kaka_net/src/interceptor/logging_interceptor.dart';
import 'package:kaka_net/src/request/kaka_base_request.dart';


import '../core/kaka_net_adapter.dart';
import '../core/kaka_net_error.dart';

///Dio适配器
class DioAdapter extends KaKaNetAdapter {
  late Dio _dio;

  DioAdapter(String baseUrl) : super(baseUrl) {
    var options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 5000,
        receiveTimeout: 5000);
    _dio = Dio(options);
    //日志拦截器
    _dio.interceptors.add(LoggingInterceptor());
  }

  @override
  Future<KaKaNetResponse<dynamic>> send(KaKaBaseRequest request) async {
    try {
      var response;
      //这儿其实可以用dio.request来实现传入对应的method
      switch (request.httpMethod()) {
        case HttpMethod.POST:
          response = await _post(request);
          break;
        case HttpMethod.GET:
          response = await _get(request);
          break;
        case HttpMethod.DELETE:
          response = await _delete(request);
          break;
      }
      //只需返回KaKaNetResponse<T>，Dart会自动将返回值包装成Future对象
      return handleResponse(response, request);
    } on DioError catch (e) {
      return KaKaNetResponse.error(
          error: handleOtherDioError(e), request: request);
    } catch (e) {
      return KaKaNetResponse.error(
          error: handleOtherError(e), request: request);
    }
  }

  _post(KaKaBaseRequest request) async {
    _dio.options.headers = request.headers;
    return _dio.post(request.url(), queryParameters: request.params);
  }

  _get(KaKaBaseRequest request) async {
    _dio.options.headers = request.headers;
    var result = _dio.get(request.url(), queryParameters: request.params);
    return result;
  }

  _delete(KaKaBaseRequest request) async {
    _dio.options.headers = request.headers;
    return _dio.delete(request.url(), queryParameters: request.params);
  }

  KaKaNetResponse handleResponse(
      Response response, KaKaBaseRequest request) {
    if (response.statusCode == 200) {
      //成功
      return KaKaNetResponse.completed(data: response.data, request: request);
    } else {
      //失败
      return KaKaNetResponse.error(
          error: KaKaNetError(response.statusCode, response.statusMessage),
          request: request);
    }
  }

  ///处理Dio错误
  KaKaNetError handleOtherDioError(DioError error) {
    switch (error.type) {
      case DioErrorType.response:
        return KaKaNetError(KaKaErrorCode.HTTP_ERROR, error.message,
            data: KaKaErrorData(
                code: error.response?.statusCode,
                message: error.response?.statusMessage));
      case DioErrorType.connectTimeout:
      case DioErrorType.receiveTimeout:
      case DioErrorType.sendTimeout:
        return KaKaNetError(KaKaErrorCode.TIMEOUT_ERROR, error.message,
            data: KaKaErrorData(
                code: error.response?.statusCode,
                message: error.response?.statusMessage));
      default:
        return KaKaNetError(KaKaErrorCode.OTHER_ERROR, error.message,
            data: KaKaErrorData(
                code: error.response?.statusCode,
                message: error.response?.statusMessage));
    }
  }

  KaKaNetError handleOtherError(error) {
    return KaKaNetError(KaKaErrorCode.UNKNOWN, "unknown error",
        data: KaKaErrorData(error: error));
  }
}
