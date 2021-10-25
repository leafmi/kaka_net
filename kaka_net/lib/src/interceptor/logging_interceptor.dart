import 'package:dio/dio.dart';
import 'package:kaka_net/src/log/kaka_log.dart';

///日志拦截器
class LoggingInterceptor extends Interceptor {
  ///最大字符行
  int _maxCharactersPerLine = 900;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    kaKaNetLog("--> ${options.method} ${options.baseUrl}${options.path}");
    kaKaNetLog("Content type: ${options.contentType}");
    kaKaNetLog("Headers: ${options.headers}");
    kaKaNetLog("<-- END ${options.method}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    kaKaNetLog(
        "<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.baseUrl}${response.requestOptions.path}");

    String responseAsString = response.data.toString();
    if (responseAsString.length > _maxCharactersPerLine) {
      int iterations =
          (responseAsString.length / _maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * _maxCharactersPerLine + _maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
        kaKaNetLog(responseAsString
            .substring(i * _maxCharactersPerLine, endingIndex)
            .toString());
      }
    } else {
      kaKaNetLog(responseAsString);
    }
    kaKaNetLog("<-- END HTTP");

    super.onResponse(response, handler);
  }
}
