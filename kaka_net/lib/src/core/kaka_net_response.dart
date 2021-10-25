import 'dart:convert';

import 'package:kaka_net/src/request/kaka_base_request.dart';

import 'kaka_net_error.dart';

///最后服务器响应的数据，正常信息、错误信息及状态，当前响应正常是data一定是有值的，错误时error一定是有点值的
///这儿可以改进就是返回的数据是一个可null类型，拿到后需要转换，不爽后期改进类似密封类
class KaKaNetResponse<T> {
  ///响应正常时的构造函数
  KaKaNetResponse.completed(
      {required this.data, required this.request, this.error})
      : status = KaKaResponseStatus.COMPLETED;

  ///响应错误事的构造函数
  KaKaNetResponse.error({this.data, required this.error, required this.request})
      : status = KaKaResponseStatus.ERROR;

  ///正常数据
  T? data;

  ///请求信息
  KaKaBaseRequest request;

  ///响应状态，互斥
  KaKaResponseStatus status;

  ///响应错误信息
  KaKaNetError? error;

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }
}

///Response 状态
enum KaKaResponseStatus { COMPLETED, ERROR }
