import 'package:dio/dio.dart';
import 'package:kaka_net/src/interceptor/kaka_base_parse_interceptor.dart';

import 'kaka_base_response.dart';

enum HttpMethod { GET, POST, DELETE, PUT }

///请求配置信息
abstract class KaKaBaseRequest<T> {
  Map<String, dynamic> params = Map();
  Map<String, dynamic> headers = Map();
  dynamic data;

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

  ///设置请求体
  KaKaBaseRequest setData(data) {
    this.data = data;
    return this;
  }

  @override
  String toString() {
    return 'KaKaBaseRequest{baseUrl: ${baseUrl()}, '
        'path: ${url()},httpMethod: ${httpMethod()},'
        'params: $params,header: $headers}';
  }

  List<Interceptor>? interceptors() {
    return null;
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

  //是否忽略请求返回的Response，如果忽略只要http code 等于200则请求成功，否则则要解析response正确并不未空才返回请求成功
  bool ignoreResponse() {
    return false;
  }
}
