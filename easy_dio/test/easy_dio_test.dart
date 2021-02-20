import 'dart:core';

import 'package:easy_dio/easy_dio.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('adds one to input values', () {
    //web
    var urlWeb = "http://www.baidu.com";
    //Json
    var urlJson2 = "https://jsonplaceholder.typicode.com/posts";

    // This is big file(about 200M)
    var urlLarge = "http://download.dcloud.net.cn/HBuilder.9.0.2.macosx_64.dmg";
    // This is small img(about 90K)
    var urlSmall =
        "https://cdn.jsdelivr.net/gh/flutterchina/flutter-in-action@1.0/docs/imgs/book.jpg";

    var urlGzip = "https://api-dev.yeedev.com/apis/iot/v1/device/r/tree";

    YeeHttpBuilder _yeeHttpBuilder = new YeeHttpBuilder()
           .baseUrl("https://jsonplaceholder.typicode.com/posts")
           .method(HttpConfigs.GET)
           .build();
     _yeeHttpBuilder.asyncRequest(); //first request form Intent
  });
}

