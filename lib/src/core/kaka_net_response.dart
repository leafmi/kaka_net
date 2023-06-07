import 'dart:convert';

import 'package:kaka_net/src/request/kaka_base_request.dart';

import 'kaka_net_error.dart';

sealed class KaKaResponse<T> {
  ///请求信息
  KaKaBaseRequest<T> request;

  KaKaResponse(this.request);
}

class Success<T> extends KaKaResponse<T> {
  ///正常数据
  T data;

  Success(super.request, this.data);
}

class Error<T> extends KaKaResponse<T> {
  ///响应错误信息
  KaKaNetError error;

  Error(super.request, this.error);
}
