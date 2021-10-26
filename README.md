# kaka_net
kaka_net是Flutter网络层封装框架，统一项目网络请求、错误处理、多域名支持、请求结果数据解析及BaseResponse的处理。框架使用Adapter设计模式可灵活切换底层请求库，现已实现Dio

### 如何使用
· 构建请求Request，配置请求参数及结果数据解析规则

```dart
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
  KaKaBaseResponse? parseBaseResponse(data) {
    return BaseResponse.fromJson(data);
  }

  ///是否开启BaseResponse解析，不开启则是将获取请求的数据直接进行parseData解析
  @override
  bool enableParseBaseData() {
    return true;
  }
}
```
· 调用发送请求

```dart
  _test() async{
    var request = TestRequest();
    //请求结果及所得不包含其他干扰数据
    var result = await KaKaNet.getInstance().fire<List<TestModel>>(request);
    if(result.status == KaKaResponseStatus.COMPLETED) {
      print(result.data.toString());
    }else {
      print("KaKaNet:${result.error?.message}-${result.error?.data}");
    }
  }
```
