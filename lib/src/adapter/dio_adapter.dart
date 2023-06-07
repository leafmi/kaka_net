import 'package:kaka_net/kaka_net.dart';
import 'package:kaka_net/src/interceptor/logging_interceptor.dart';

import '../core/kaka_net_adapter.dart';

///Dio适配器
class DioAdapter extends KaKaNetAdapter {
  late Dio _dio;

  DioAdapter(String baseUrl, List<Interceptor>? interceptors) : super(baseUrl) {
    var options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10));
    _dio = Dio(options);
    //日志拦截器
    _dio.interceptors.add(LoggingInterceptor());
    //添加自定义拦截器
    if (interceptors != null && interceptors.isNotEmpty) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  @override
  Future<dynamic> send(KaKaBaseRequest request) async {
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
        case HttpMethod.PUT:
          response = await _put(request);
          break;
      }
      //只需返回KaKaNetResponse<T>，Dart会自动将返回值包装成Future对象
      return handleResponse(response, request);
    } on DioException catch (e) {
      throw handleOtherDioError(e);
    } catch (e) {
      throw handleOtherError(e);
    }
  }

  _post(KaKaBaseRequest request) async {
    _dio.options.headers = request.headers;
    dynamic data;
    if (request.data == null) {
      data = request.params;
    } else {
      data = request.data;
    }
    return _dio.post(request.url(), data: data);
  }

  _put(KaKaBaseRequest request) async {
    _dio.options.headers = request.headers;
    dynamic data;
    if (request.data == null) {
      data = request.params;
    } else {
      data = request.data;
    }
    return _dio.put(request.url(), data: data);
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

  dynamic handleResponse(Response response, KaKaBaseRequest request) {
    if (response.statusCode == 200) {
      //成功
      return response.data;
    } else {
      //失败
      throw KaKaNetError(response.statusCode, response.statusMessage);
    }
  }

  ///处理Dio错误
  KaKaNetError handleOtherDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.badResponse:
        return KaKaNetError(KaKaErrorCode.HTTP_ERROR, error.message,
            data: KaKaErrorData(
                code: error.response?.statusCode,
                message: error.response?.statusMessage));
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
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
