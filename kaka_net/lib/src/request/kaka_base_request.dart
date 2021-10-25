
import 'kaka_base_response.dart';

enum HttpMethod { GET, POST, DELETE }

///请求配置信息
abstract class KaKaBaseRequest<T> {
  Map<String, dynamic> params = Map();
  Map<String, dynamic> headers = Map();

  String baseUrl() {
    return "";
  }

  String url();

  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  ///添加参数
  KaKaBaseRequest addParam(String k, dynamic v) {
    params[k] = v;
    return this;
  }

  ///添加头
  KaKaBaseRequest addHeader(String k, dynamic v) {
    headers[k] = v;
    return this;
  }

  @override
  String toString() {
    return 'KaKaBaseRequest{baseUrl: ${baseUrl()}, '
        'path: ${url()},httpMethod: ${httpMethod()},'
        'params: $params,header: $headers}';
  }

  T? parseData(dynamic data) {
    return null;
  }

  KaKaBaseResponse? parseBaseResponse(dynamic data) {
    return null;
  }

  bool enableParseBaseData() {
    return false;
  }

  int responseSuccessCode() {
    return 0;
  }
}
