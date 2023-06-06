import 'dart:collection';

import 'package:kaka_net/src/interceptor/kaka_base_parse_interceptor.dart';

import 'adapter/dio_adapter.dart';
import 'core/kaka_net_adapter.dart';
import 'core/kaka_net_error.dart';
import 'core/kaka_net_response.dart';
import 'parse/parse_response_data.dart';
import 'request/kaka_base_request.dart';

///KaKaNet
class KaKaNet {
  HashMap<String, KaKaNetAdapter> kaKaNetAdapterMap = HashMap();

  KaKaNet._();
KakaBaseParseInterceptor? parseInterceptor;
  static KaKaNet? _instance;

  static KaKaNet getInstance() {
    if (_instance == null) {
      _instance = KaKaNet._();
    }
    return _instance!;
  }

  ///外部调用请求接口
  Future<KaKaNetResponse<T>> fire<T>(KaKaBaseRequest<T> request) async {
    var result = await _send(request);
    if (result.status == KaKaResponseStatus.COMPLETED) {
      if (request.enableParseBaseData()) {
        return parseResponse(result.data, request);
      } else {
        var responseData = request.parseData(result.data);
        if (responseData == null) {
          return KaKaNetResponse.error(
              error: parseDataError("parse data null"), request: request);
        }
        return KaKaNetResponse.completed(data: responseData, request: request);
      }
    } else {
      return KaKaNetResponse.error(error: result.error, request: request);
    }
  }

  ///核心请求
  Future<KaKaNetResponse<dynamic>> _send(KaKaBaseRequest request) async {
    var baseUrl = request.baseUrl();
    if (baseUrl.isEmpty || baseUrl.isEmpty) {
      //未设置baseUrl,直接抛出异常
      return KaKaNetResponse.error(
          error: KaKaNetError(
              KaKaErrorCode.NOT_SET_BASE_URL_ERROR, "request baseUrl not set"),
          request: request);
    }
    //先获取缓存，实现多域名（需改进不应该每次都创建）
    var netAdapter = kaKaNetAdapterMap[baseUrl];

    if (netAdapter == null) {
      netAdapter = DioAdapter(baseUrl, request.interceptors());
      kaKaNetAdapterMap[baseUrl] = netAdapter;
    }

    return netAdapter.send(request);
  }
}
