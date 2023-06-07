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

  /// The instance of the [KaKaNet] to use.
  static KaKaNet get instance => _getOrCreateInstance();

  static KaKaNet _getOrCreateInstance() {
    if (_instance != null) {
      return _instance!;
    }
    _instance = KaKaNet._();
    return _instance!;
  }

  ///外部调用请求接口
  Future<KaKaResponse<T>> fire<T>(KaKaBaseRequest<T> request) async {
    try {
      var result = await _send(request);
      if (request.enableParseBaseData()) {
        return parseResponse(result.data, request);
      } else {
        return Success(request, result);
      }
    } on KaKaNetError catch (e) {
      return Error(request, e);
    } catch (e) {
      return Error(
          request,
          KaKaNetError(KaKaErrorCode.UNKNOWN, e.toString(),
              data: KaKaErrorData(error: e)));
    }
  }

  ///核心请求
  Future<dynamic> _send(KaKaBaseRequest request) async {
    var baseUrl = request.baseUrl();
    if (baseUrl.isEmpty || baseUrl.isEmpty) {
      //未设置baseUrl,直接抛出异常
      throw KaKaNetError(
          KaKaErrorCode.NOT_SET_BASE_URL_ERROR, "request baseUrl not set");
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
