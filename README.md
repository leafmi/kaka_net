# kaka_net
### 使用
· 构建请求Request
```
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
}

· 调用发送请求
```
  _test() async{
    var request = TestRequest();
    var result = await KaKaNet.getInstance().fire<List<TestModel>>(request);
    if(result.status == KaKaResponseStatus.COMPLETED) {
      print(result.data.toString());
    }else {
      print("KaKaNet:${result.error?.message}-${result.error?.data}");
    }
  }
```dar



```
