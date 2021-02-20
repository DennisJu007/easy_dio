part of '../easy_dio.dart';

///Callback for asyncRequest
abstract class OnRequestCallBack
    implements OnRequestPreview, OnRequestResponse, OnRequestError {}

///Callback for asyncRequest
abstract class OnRequestPreview {
  dynamic onPreRequest(YeeRequestOption requestOption);
}

///Callback for asyncRequest
abstract class OnRequestResponse {
  void onResponse(YeeResponse response);
}

///Callback for asyncRequest
abstract class OnRequestError {
  void onError(YeeDioError e);
}

/// - [Usage] asyncRequest:
///
/// 1. class _MyHomePageState extends State<MyHomePage> implements OnRequestCallBack
///  @override
///  dynamic onPreRequest(YeeRequestOption request);
///  @override
///  void onError(YeeDioError e) {}
///  @override
///  void onResponse(YeeResponse result) {}
///
/// 2.How to crate a asyncRequest builder
///    YeeHttpBuilder _yeeHttpBuilder = new YeeHttpBuilder(context: this)
///        .baseUrl("https://jsonplaceholder.typicode.com/posts")
///        .method(HttpConfigs.GET)
///        .build();
///   NOTE: if params is form-urlencoded please set this.formDataParams(true)
///
/// 3.To async request the jsonToBean object（type:dynamic）
///    _yeeHttpBuilder.asyncRequest();
///
/// 4.Destroy builder while widget will be in background, Every builder has itself cancelToken
///    _yeeHttpBuilder.cancelToken(true);
///
///
/// - [Usage] syncRequest:
/// 1.YeeHttpBuilder _yeeHttpBuilder = new YeeHttpBuilder()
///       .baseUrl("https://jsonplaceholder.typicode.com/posts")
///       .method(HttpConfigs.GET)
///       .build();
/// 2.To sync receive the jsonToBean object（type:dynamic）
///   dynamic response =  await _yeeHttpBuilder.syncRequest();
///
/// - [Usage] Download:
/// Tips: While file's size more than 5MB, we recommend using downloadLargeFile to increase download speed , another side we use downloadSmallFile
/// 1.  YeeHttpBuilder builder = new YeeHttpBuilder(ignoreDefaultHttpConfig: true)
///        .method(HttpConfigs.GET)
///        .baseUrl(urlLarge)
///        .log(true)
///        .build();
///
/// 2. dynamic result = await builder.downloadLargeFile(
///        "[your save path]", onReceiveProgress: (received, total) async{
///      if (total != -1) {
///        print("progress:" + (received / total * 100).toStringAsFixed(0) + "%");
///      }
///    });
///
/// - [Usage] CacheInterceptor
/// 1.Tips: There's always some data we don't need it in real time so we can ask for it from http cache
///   YeeHttpBuilder builder = new YeeHttpBuilder()
///        .method(HttpConfigs.GET)
///        .baseUrl(urlWeb)
///        .addInterceptor(CacheInterceptor())
///        .log(true)
///        .build();
///
///  2.await builder.syncRequest(); //first request form Intent
///    await builder.syncRequest(); //second request form our local cache
///    builder.forceRefreshCache(true);//ignore local cache， ask for data from Intent
///    await builder.syncRequest();//third request form Intent again
///
/// - [Usage] Verify Https Certificate:
/// 1.Custom your certificate by setting pem string with YeeHttpBuilder.httpsCertificate(certificate)
///
/// 2.【Not Recommending】Ignore verify by setting YeeHttpBuilder.verifyHttpsCertificate(false), default value{true}.
///
///     YeeHttpBuilder builder = new YeeHttpBuilder()
///        .method(HttpConfigs.GET)
///        .baseUrl(urlJson)
///        .log(true)
///        .httpsCertificate("your pem string") //custom https certificate which format is pem
///        .verifyHttpsCertificate(false) //ignore https verify, Not Recommend!!!
///        .build();
///
/// - [Usage] Params Type: Map(default)\FormData
/// 1.Map<String, dynamic>
/// 2.YeeHttpBuilder.formDataParams(true) transform Map to FormData
///
///- [Usage] Track Request: You can set one more id(.id("xxx)) for every YeeHttpBuilder instance to  mark every network request
///  1. if not we support default id for you {@link _createDefaultUniqueKey()}
///  2. YeeHttpBuilder _yeeHttpBuilder = new YeeHttpBuilder()
///      .baseUrl("https://jsonplaceholder.typicode.com/posts")
///      .method(HttpConfigs.GET)
///      .id("your mark")
///      .build();
///  3.you can track "your mark" in {@link OnRequestCallBack}method like:
///   @override
///  void onResponse(YeeResponse response) {
///    print("YeeHttpBuilderUtil_onResponse:");
///    if (response.builderID() == "your mark") {
///      //TODO your deal
///    }
///    if (response.builderID() == "another mark") {
///      //TODO your deal
///    }
///  }
///
const String DEFAULT_SERVER_HTTPS_CERT =
    "-----BEGINCERTIFICATE-----XXX-----ENDCERTIFICATE-----";

class YeeHttpBuilder extends DioSettingBuilder {
  OnRequestCallBack _onRequestCallBack;

  set setRequestCallBack(OnRequestCallBack context) {
    this._onRequestCallBack = context;
  }

  //finish build flag
  bool _isBuild;

  ///request Params
  dynamic _requestParams;

  /// request files
  Map<String, dynamic> _requestFiles;

  ///request Params to FormData
  bool _isFormDataParams;

  ///request network framework
  Dio _requestDio;

  ///Url subContent never should be null
  String _path = "";

  ///Dio cancel flag
  CancelToken _cancelToken;

  ///Common print log flag， default not show any log
  static bool showLog = false;

  ///Liskov Substitution Principle for common setting
  Options _buildOptions;

  ///https verify certificate
  String _httpsCert = DEFAULT_SERVER_HTTPS_CERT;

  ///Do you need to verify https certificate
  bool _verifyHttpsCert;

  ///The uniqueKey of YeeHttpBuilder, which you can deal callback data with it.
  String _uniqueID = "";

  ///Custom network error {@link YeeDioErrorType}
  YeeDioErrorType _errorType;

  // @params context which implement it
  // @params ignoreDefaultHttpConfig like: download request doesn't need defaultOption config except creating instance of Dio
  YeeHttpBuilder(
      {OnRequestCallBack context,
      bool ignoreDefaultHttpConfig = false,
      bool verifyHttpsCert = true}) {
    this._requestDio = new Dio();
    this._cancelToken = CancelToken();
    this._onRequestCallBack = context;
    this._isFormDataParams = false;
    this._isBuild = false;
    this._verifyHttpsCert = true;

    if (ignoreDefaultHttpConfig != null && !ignoreDefaultHttpConfig) {
      _initHttpConfig();
    }
  }

  _initHttpConfig() {
    this._requestDio.options = DioBaseOption.defaultOption;
  }

  ///Https Certificate Verification
  _verifyHttpsCertificate() {
    (this._requestDio.httpClientAdapter as DefaultHttpClientAdapter)
        .onHttpClientCreate = (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        String aimPem = this._removeStrWhiteSpace(cert.pem);
        String verifyPem = this._removeStrWhiteSpace(this._httpsCert);
        //Note: if not necessary,not recommending ignore https's verification
        if (!this._verifyHttpsCert) {
          return true;
        }
        if (aimPem == verifyPem) {
          // Verify the certificate
          return true;
        }
        return false;
      };
    };
  }

  @override
  YeeHttpBuilder baseUrl(String url) {
    this._requestDio.options.baseUrl = url;
    return this;
  }

  @override
  YeeHttpBuilder path(String path) {
    this._path = path;
    return this;
  }

  @override
  YeeHttpBuilder contentType(String contentType) {
    this._requestDio.options.contentType = contentType;
    return this;
  }

  @override
  YeeHttpBuilder responseType(YeeResponseType responseType) {
    ResponseType type = ResponseType.json;
    switch (responseType) {
      case YeeResponseType.json:
        type = ResponseType.json;
        break;
      case YeeResponseType.plain:
        type = ResponseType.plain;
        break;
      case YeeResponseType.bytes:
        type = ResponseType.bytes;
        break;
//      case YeeResponseType.stream:
//        type = ResponseType.stream;
        break;
    }
    this._requestDio.options.responseType = type;
    return this;
  }

  @override
  YeeHttpBuilder params(dynamic params) {
    this._requestParams = params;
    return this;
  }

  //@files files(Map<String, File) or files(Map<String, List<File>)
  @override
  YeeHttpBuilder files(Map<String, dynamic> files) {
    this._requestFiles = files;
    return this;
  }

  @override
  YeeHttpBuilder formDataParams(bool isFormData) {
    this._isFormDataParams = isFormData;
    return this;
  }

  @override
  YeeHttpBuilder method(String method) {
    this._requestDio.options.method = method;
    return this;
  }

  @override
  YeeHttpBuilder connectTimeout(int connectTimeout) {
    this._requestDio.options.connectTimeout = connectTimeout;
    return this;
  }

  @override
  YeeHttpBuilder receiveTimeout(int receiveTimeout) {
    this._requestDio.options.receiveTimeout = receiveTimeout;
    return this;
  }

  @override
  YeeHttpBuilder header(Map<String, dynamic> header) {
    this._requestDio.options.headers = header;
    return this;
  }

  @override
  YeeHttpBuilder log(bool hideLog) {
    showLog = hideLog;
    this._requestDio.interceptors.add(LogInterceptor(
        request: showLog,
        requestHeader: showLog,
        requestBody: showLog,
        responseHeader: showLog,
        responseBody: showLog,
        error: showLog,
      )); //open/close logs
    return this;
  }

  @override
  YeeHttpBuilder addInterceptor(Interceptor interceptor) {
    if (interceptor != null) {
      this._requestDio.interceptors.add(interceptor);
    } else {
      throw Exception("Interceptor is null");
    }
    return this;
  }

  @override
  YeeHttpBuilder followRedirects(bool follow) {
    this._requestDio.options.followRedirects = follow;
    return this;
  }

  @override
  YeeHttpBuilder forceRefreshCache(bool refresh) {
    this._requestDio.options.extra?.clear();
    this
        ._requestDio
        .options
        .extra
        .addAll({CacheInterceptor.EXTRA_REFRESH_KEY: true});
    return this;
  }

  @override
  YeeHttpBuilder extra(Map<String, dynamic> extra) {
    this._requestDio.options.extra?.clear();
    this._requestDio.options.extra.addAll(extra);
    return this;
  }

  @override
  YeeHttpBuilder httpsCertificate(String certificate) {
    _httpsCert = certificate;
    return this;
  }

  @override
  YeeHttpBuilder verifyHttpsCertificate(bool verify) {
    _verifyHttpsCert = verify;
    return this;
  }

  @override
  YeeHttpBuilder id(String id) {
    this._uniqueID = id;
    return this;
  }

  String getUniqueKey() {
    return this._uniqueID;
  }

  String _createDefaultUniqueKey() {
    BaseOptions baseOptions = this._requestDio.options;
    return baseOptions.baseUrl +
        baseOptions.method +
        baseOptions.extra?.toString();
  }

  ///check and build request config
  YeeHttpBuilder build() {
    this._isBuild = true;
    _verifyHttpsCertificate();
    _buildAsyncCallBack();
    _buildCommonOptionConfig();
    return this;
  }

  ///asyncRequest in callback deal result and request can be cancelled
  //@params toBean change original data to bean
  //@params jsonBeanClass aim jsonToBean Object
  void asyncRequest() {
    this._checkBuildOperation();
    switch (this._requestDio.options.method) {
      case HttpConfigs.GET:
        this._requestGet();
        break;
      case HttpConfigs.POST:
        this._requestPost();
        break;
      case HttpConfigs.PUT:
        this._requestPut();
        break;
      case HttpConfigs.DELETE:
        this._requestDelete();
        break;
      default:
        throw UnsupportedError(
            this._requestDio.options.method + " unsupport now");
        break;
    }
  }

  ///syncRequest the response can be use directly
  dynamic syncRequest() async {
    this._checkBuildOperation();
    try {
      Response response;
      switch (this._requestDio.options.method) {
        case HttpConfigs.GET:
          response = await this._requestGet();
          break;
        case HttpConfigs.POST:
          response = await this._requestPost();
          break;
        case HttpConfigs.PUT:
          response = await this._requestPut();
          break;
        case HttpConfigs.DELETE:
          response = await this._requestDelete();
          break;
        default:
          throw UnsupportedError(
              this._requestDio.options.method + " unsupport now");
          break;
      }
      return response;
    } catch (e) {
      return null;
    }
  }

  ///Cancel asyncRequest
  void cancelToken(bool cancelToken) {
    if (cancelToken) {
      _cancelToken?.cancel("Request cancelled");
    }
  }

  /// Downloading and return stream ,default get request
  Future downloadSmallFile(String savePath, {onReceiveProgress}) async {
    _checkBuildOperation();
    dynamic tempParams = _transformParamsType();
    return await this._requestDio.download(
        this._requestDio.options.baseUrl, savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: tempParams,
        data: tempParams,
        cancelToken: this._cancelToken,
        options: this._buildOptions);
  }

  /// Downloading by spiting as file in chunks
  Future downloadLargeFile(
    savePath, {
    ProgressCallback onReceiveProgress,
  }) async {
    _checkBuildOperation();
    const firstChunkSize = 102;
    const maxChunk = 3;
    var url = this._requestDio.options.baseUrl;
    int total = 0;
    var dio = this._requestDio;
    var progress = <int>[];

    createCallback(no) {
      return (int received, _) {
        progress[no] = received;
        if (onReceiveProgress != null && total != 0) {
          onReceiveProgress(progress.reduce((a, b) => a + b), total);
        }
      };
    }

    Future<Response> downloadChunk(url, start, end, no) async {
      progress.add(0);
      --end;
      return dio.download(
        url,
        savePath + "temp$no",
        onReceiveProgress: createCallback(no),
        options: Options(
          headers: {"range": "bytes=$start-$end"},
        ),
      );
    }

    Future mergeTempFiles(chunk) async {
      File f = File(savePath + "temp0");
      IOSink ioSink = f.openWrite(mode: FileMode.writeOnlyAppend);
      for (int i = 1; i < chunk; ++i) {
        File _f = File(savePath + "temp$i");
        await ioSink.addStream(_f.openRead());
        await _f.delete();
      }
      await ioSink.close();
      await f.rename(savePath);
    }

    Response response = await downloadChunk(url, 0, firstChunkSize, 0);
    if (response.statusCode == 206) {
      total = int.parse(response.headers
          .value(HttpHeaders.contentRangeHeader)
          .split("/")
          .last);
      int reserved = total -
          int.parse(response.headers.value(Headers.contentLengthHeader));
      int chunk = (reserved / firstChunkSize).ceil() + 1;
      if (chunk > 1) {
        int chunkSize = firstChunkSize;
        if (chunk > maxChunk + 1) {
          chunk = maxChunk + 1;
          chunkSize = (reserved / maxChunk).ceil();
        }
        var futures = <Future>[];
        for (int i = 0; i < maxChunk; ++i) {
          int start = firstChunkSize + i * chunkSize;
          futures.add(downloadChunk(url, start, start + chunkSize, i + 1));
        }
        await Future.wait(futures);
      }
      await mergeTempFiles(chunk);
    }
  }

  ///Support params's type: Map\FormData
  dynamic _transformParamsType() {
    if(this._requestFiles != null) {
      if(this._requestParams == null) {
        this._requestParams = Map<String, dynamic>();
      }
      this._requestFiles.forEach((String key, dynamic value){
        if(value is File) {
          this._requestParams[key] = MultipartFile.fromFileSync(value.path);
        } else if(value is List<File>) {
          List<MultipartFile> multiFiles = List();
          value.forEach((file){
            if(file is File) {
              multiFiles.add(MultipartFile.fromFileSync(file.path));
            }
          });
          this._requestParams[key] = multiFiles;
        }
      });
      return FormData.fromMap(this._requestParams);
    } else if (this._requestParams == null) {
      return this._requestParams;
    } else if (this._isFormDataParams) {
      return FormData.fromMap(this._requestParams);
    }
    return this._requestParams;
  }

  dynamic _requestGet() {
    dynamic tempParams = _transformParamsType();
    return this._requestDio.get(this._path,
        queryParameters: tempParams,
        cancelToken: this._cancelToken,
        options: this._buildOptions);
  }

  dynamic _requestPost() {
    dynamic tempParams = _transformParamsType();
    return this._requestDio.post(this._path,
        data: tempParams,
        cancelToken: this._cancelToken,
        options: this._buildOptions);
  }

  dynamic _requestPut() {
    dynamic tempParams = _transformParamsType();
    return this._requestDio.put(this._path,
        data: tempParams,
        cancelToken: this._cancelToken,
        options: this._buildOptions);
  }

  dynamic _requestDelete() {
    dynamic tempParams = _transformParamsType();
    return this._requestDio.delete(this._path,
        data: tempParams,
        cancelToken: this._cancelToken,
        options: this._buildOptions);
  }

  _buildAsyncCallBack() {
    this
        ._requestDio
        .interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
          // Do something before request is sent
          var connectivityResult =
              await (new Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.none) {
            this._errorType = YeeDioErrorType.NETWORK_ERROR;
          } else {
            this._errorType = null;
          }
          dynamic tempOptions = this
              ._onRequestCallBack
              ?.onPreRequest(YeeRequestOption(options, id: this._uniqueID));
          return tempOptions != null ? tempOptions : options; //continue
          // If you want to resolve the request with some custom data，
          // you can return a `Response` object or return `dio.resolve(data)`.
          // If you want to reject the request with a error message,
          // you can return a `DioError` object or return `dio.reject(errMsg)`
        }, onResponse: (Response response) async {
          // Do something with response data
          return this._onRequestCallBack?.onResponse(
              YeeResponse(response, id: this._uniqueID)); // continue
        }, onError: (DioError e) async {
          YeeDioError yeeError =
              YeeDioError(e, id: this._uniqueID, type: this._errorType);

          FlutterErrorDetails details = FlutterErrorDetails(
            exception: yeeError,
            library: 'iot net work library',
          );
          //报告错误
          FlutterError.reportError(details);

          // Do something with response error
          return this._onRequestCallBack?.onError(YeeDioError(e,
              id: this._uniqueID, type: this._errorType)); //continue
        }));
  }

  _buildCommonOptionConfig() {
    BaseOptions baseOptions = this._requestDio.options;
    _buildOptions = Options(
        method: baseOptions.method,
        extra: baseOptions.extra,
        responseType: baseOptions.responseType,
        contentType: baseOptions.contentType,
        followRedirects: baseOptions.followRedirects);
  }

  void _checkBuildOperation() {
    if (!this._isBuild) {
      throw Exception(
          "Please call the '.build()'for YeeHttpBuilder's intance before calling (a)syncRequest()!");
    } else {
      //make sure every request has set default uniqueID
      if (this._uniqueID == null || this._uniqueID.length <= 0){
        this._uniqueID = this._createDefaultUniqueKey();
      }
      //set response language for every request
      final String defaultLocale = Platform.localeName;
      this._requestDio.options.headers.addAll({'Accept-language': defaultLocale});
    }
  }

  String _removeStrWhiteSpace(String resStr) {
    return resStr.replaceAll(new RegExp(r"\s|\b|\n"), "");
  }
}
