import 'package:kaka_net/kaka_net.dart';
import 'package:kaka_net/src/core/kaka_net_error.dart';
import 'package:kaka_net/src/core/kaka_net_response.dart';
import 'package:kaka_net/src/interceptor/kaka_base_parse_interceptor.dart';
import 'package:kaka_net/src/request/kaka_base_request.dart';

Future<KaKaNetResponse<T>> parseResponse<T>(
    data, KaKaBaseRequest<T> request) async {
  try {
    var baseResponse = request.parseBaseResponse(data);
    if (baseResponse == null) {
      return KaKaNetResponse.error(
          error: parseDataError("parse baseResponse is null"),
          request: request);
    }

    if (baseResponse.code != request.responseSuccessCode()) {
      KaKaNetResponse<T> er = KaKaNetResponse.error(
          error: KaKaNetError(
              KaKaErrorCode.RESPONSE_CODE_ERROR, baseResponse.msg,
              data: KaKaErrorData(
                  code: baseResponse.code, message: baseResponse.msg)),
          request: request);
      // request.parseInterceptor?.onResponseError(er.error);
      KaKaNet.getInstance().parseInterceptor?.onResponseError(er.error);

      ///服务器返回错误数据
      return er;
    }
    try {
      var responseData = request.parseData(baseResponse.data);
      if (responseData == null) {
        return KaKaNetResponse.error(
            error: parseDataError("parse data null"), request: request);
      }

      return KaKaNetResponse.completed(data: responseData, request: request);
    } catch (e) {
      return KaKaNetResponse.error(
          error: parseDataError(e.toString()), request: request);
    }
  } catch (e) {
    return KaKaNetResponse.error(
        error: parseDataError(e.toString()), request: request);
  }
}

KaKaNetError parseDataError(String extraMsg) {
  return KaKaNetError(KaKaErrorCode.PARSE_ERROR,
      "service response data is null,Possible reasons are that the server returned null data or json parsing error or did not rewrite the parseData method in KaKaBaseRequest to parse the data",
      data: KaKaErrorData(message: extraMsg));
}
