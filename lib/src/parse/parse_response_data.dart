import 'package:kaka_net/kaka_net.dart';

Future<KaKaResponse<T>> parseResponse<T>(
    data, KaKaBaseRequest<T> request) async {
  try {
    var baseResponse = request.parseBaseResponse(data);
    if (baseResponse == null) {
      return Error(request, parseDataError("parse baseResponse is null"));
    }

    if (baseResponse.code != request.responseSuccessCode()) {
      var error = Error<T>(
          request,
          KaKaNetError(KaKaErrorCode.RESPONSE_CODE_ERROR, baseResponse.msg,
              data: KaKaErrorData(
                  code: baseResponse.code, message: baseResponse.msg)));
      KaKaNet.instance.parseInterceptor?.onResponseError(error.error);

      ///服务器返回错误数据
      return error;
    }
    try {
      var responseData = request.parseData(baseResponse.data);
      if (responseData == null) {
        return Error(request, parseDataError("parse data null"));
      }
      return Success(request, responseData);
    } catch (e) {
      return Error(request, parseDataError(e.toString()));
    }
  } catch (e) {
    return Error(request, parseDataError(e.toString()));
  }
}

KaKaNetError parseDataError(String extraMsg) {
  return KaKaNetError(KaKaErrorCode.PARSE_ERROR,
      extraMsg,
      data: KaKaErrorData(message: "service response data is null,Possible reasons are that the server returned null data or json parsing error or did not rewrite the parseData method in KaKaBaseRequest to parse the data"));
}
