part of '../../easy_dio.dart';

class DioBaseOption extends BaseOptions {
  //DefaultOption
  static BaseOptions defaultOption = BaseOptions(
    // Http method.
    /// String method;
    method: HttpConfigs.POST,
    // Timeout in milliseconds for opening  url.
    /// int connectTimeout;
    connectTimeout: HttpConfigs.CONNECTION_TIME_OUT,
    //  Whenever more than [receiveTimeout] (in milliseconds) passes between two events from response stream,
    //  [Dio] will throw the [DioError] with [DioErrorType.RECEIVE_TIMEOUT].
    //  Note: This is not the receiving time limitation.
    /// int receiveTimeout;
    receiveTimeout: HttpConfigs.RECEIVE_TIME_OUT,
    // Request base url, it can contain sub path, like: "https://www.google.com/api/".
    /// String baseUrl;

    // Http request headers.
    /// Map<String, dynamic> headers;

    // Request 'data', can be any type.
    /// T data;

    // If the `path` starts with "http(s)", the `baseURL` will be ignored, otherwise,
    // it will be combined and then resolved with the baseUrl.
    ///String path="";

    // The request Content-Type. The default value is "application/json; charset=utf-8".
    // If you want to encode request body with "application/x-www-form-urlencoded",
    // you can set [Headers.formUrlEncodedContentType], and [Dio]
    // will automatically encode the request body.
    /// String contentType;

    // [responseType] indicates the type of data that the server will respond with
    // options which defined in [ResponseType] are `JSON`, `STREAM`, `PLAIN`.
    //
    // The default value is `JSON`, dio will parse response string to json object automatically
    // when the content-type of response is "application/json".
    //
    // If you want to receive response data with binary bytes, for example,
    // downloading a image, use `STREAM`.
    //
    // If you want to receive the response data with String, use `PLAIN`.
    /// ResponseType responseType;

    // `validateStatus` defines whether the request is successful for a given
    // HTTP response status code. If `validateStatus` returns `true` ,
    // the request will be perceived as successful; otherwise, considered as failed.
    ///ValidateStatus validateStatus;

    // Custom field that you can retrieve it later in [Interceptor]、[Transformer] and the   [Response] object.
    /// Map<String, dynamic> extra;

    // Common query parameters
    /// Map<String, dynamic /*String|Iterable<String>*/ > queryParameters;
  );
}

class YeeRequestOption {
  RequestOptions _requestOption;
  String _builderID;

  YeeRequestOption(requestOption, {String id}) {
    this._requestOption = requestOption;
    this._builderID = id;
  }

  String builderID() {
    return this._builderID;
  }

  dynamic originalOptions() {
    return this._requestOption;
  }

  void addToHeaders(Map<String, dynamic> headerPart) {
    if (this._requestOption.headers == null) {
      return;
    }
    this._requestOption.headers.addAll(headerPart);
  }

  String getMethod() {
    return this._requestOption?.method;
  }

  int getSendTimeout() {
    return this._requestOption?.sendTimeout;
  }

  int getReceiveTimeout() {
    return this._requestOption?.receiveTimeout;
  }

  int getConnectTimeout() {
    return this._requestOption?.connectTimeout;
  }

  /// Request data, can be any type.
  dynamic getData() {
    return this._requestOption?.data;
  }

  /// Request base url, it can contain sub path, like: "https://www.google.com/api/".
  String getBaseUrl() {
    return this._requestOption?.baseUrl;
  }

  /// If the `path` starts with "http(s)", the `baseURL` will be ignored, otherwise,
  /// it will be combined and then resolved with the baseUrl.
  String getPath() {
    return this._requestOption?.path;
  }

  /// See [Uri.queryParameters]
  Map<String, dynamic> getQueryParameters() {
    return this._requestOption?.queryParameters;
  }

  Map<String, dynamic> getExtra() {
    return this._requestOption?.extra;
  }

  Map<String, dynamic> getHeaders() {
    return this._requestOption?.headers;
  }

  String getContentType() {
    return this._requestOption?.contentType;
  }

  Uri getUri() {
    return this._requestOption?.uri;
  }

  //Use for comparing RequestOptions's value with YeeHttpBuilder.getDefaultUniqueKey()
  //if their values equal to each other means they are the same YeeHttpBuilder network request with UniqueKey
  String getDefaultUniqueKey() {
    RequestOptions options = this._requestOption;
    return options.baseUrl + options.method + options.extra?.toString();
  }
}
