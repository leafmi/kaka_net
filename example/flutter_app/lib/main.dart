import 'package:flutter/material.dart';
import 'package:flutter_app/test_model.dart';
import 'package:flutter_app/test_request.dart';
import 'package:kaka_net/kaka_net.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  _testRequest();
                },
                child: Text("请求"))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _testRequest() async {
    var request = TestRequest();
    var result = await KaKaNet.getInstance().fire<List<TestModel>>(request);
    if (result.status == KaKaResponseStatus.COMPLETED) {
      print(result.data.toString());
    } else {
      print("KaKaNet:${result.error?.message}-${result.error?.data}");
    }
  }
}
