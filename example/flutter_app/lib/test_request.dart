import 'package:flutter_app/test_model.dart';
import 'package:kaka_net/kaka_net.dart';

import 'base_response.dart';

class TestRequest extends KaKaBaseRequest<List<TestModel>> {
  @override
  String baseUrl() {
    return "https://wanandroid.com";
  }

  @override
  String url() {
    return "/wxarticle/chapters/json";
  }

  @override
  List<TestModel>? parseData(data) {
    if (data == null) {
      return null;
    }
    List<TestModel> value = [];
    data.forEach((v) {
      value.add(TestModel.fromJson(v));
    });
    return value;
  }

  @override
  int responseSuccessCode() {
    return 0;
  }

  @override
  KaKaBaseResponse? parseBaseResponse(data) {
    return BaseResponse.fromJson(data);
  }

  @override
  bool enableParseBaseData() {
    return true;
  }
}
