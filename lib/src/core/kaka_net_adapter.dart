

import 'package:kaka_net/src/request/kaka_base_request.dart';

import 'kaka_net_response.dart';

///请求适配器，若需要其他网络库，需继承实现send方法
abstract class KaKaNetAdapter {
  String baseUrl;

  KaKaNetAdapter(this.baseUrl);

  Future<dynamic> send(KaKaBaseRequest request);
}
