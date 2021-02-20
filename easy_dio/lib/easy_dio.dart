library easy_dio;

import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';

part 'src/api.dart';

part 'src/builder.dart';

part 'src/configs.dart';

part 'src/dio/interface.dart';

part 'src/dio/yee_options.dart';

part 'src/dio/yee_interceptor.dart';

part 'src/dio/yee_dio_error.dart';

part 'src/dio/yee_response.dart';