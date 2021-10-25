
import 'package:kaka_net/kaka_net.dart';

class BaseResponse with KaKaBaseResponse {
  @override
  String codeKey() {
    return "errorCode";
  }

  @override
  String msgKey() {
    return "errorMsg";
  }

  @override
  String dataKey() {
    return "data";
  }

  BaseResponse.fromJson(dynamic json) {
    code = json[codeKey()];
    data = json[dataKey()];
    msg = json[msgKey()];
  }
}
