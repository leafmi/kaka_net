///KaKa异常
class KaKaNetError implements Exception {
  final int? code;
  final String? message;
  final KaKaErrorData? data;

  KaKaNetError(this.code, this.message, {this.data});
}

///错误源信息
class KaKaErrorData {
  final int? code;
  final String? message;
  final dynamic error;

  KaKaErrorData({this.code, this.message, this.error});
}

///约定异常
class KaKaErrorCode {
  ///未知
  static const UNKNOWN = 1000;

  ///未设置base url
  static const NOT_SET_BASE_URL_ERROR = 1001;

  ///http error  401,403,404,408,500,502,503,504...
  static const HTTP_ERROR = 1002;

  ///超时(连接超时、接收超时、发送超时)
  static const TIMEOUT_ERROR = 1003;

  ///其他错误(取消...)
  static const OTHER_ERROR = 1004;

  ///请求数据response code错误
  static const RESPONSE_CODE_ERROR = 1005;

  ///请求数据response code错误
  static const RESPONSE_NULL_DATA = 1006;

  ///解析错误(解析response时错误)
  static const PARSE_ERROR = 1007;
}
