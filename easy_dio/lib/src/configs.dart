part of '../easy_dio.dart';


enum YeeResponseType {
  /// Transform the response data to JSON object only when the
  /// content-type of response is "application/json" .
  json,

  /// Transform the response data to a String encoded with UTF8.
  plain,

  /// Get original bytes, the type of Response.data will be List<int>
  bytes,
  /// Get the response stream without any transformation. The
  /// Response data will be a `ResponseBody` instance.
  ///
  ///    Response<ResponseBody> rs = await Dio().get<ResponseBody>(
  ///      url,
  ///      options: Options(
  ///        responseType: ResponseType.stream,
  ///      ),
  ///    );
  //  stream I don't hope you deal stream by yourself
}
class HttpConfigs{

  //Remote sever does not response for (ms)
  static const int CONNECTION_TIME_OUT = 10 * 1000;
  static const int RECEIVE_TIME_OUT = 8 * 1000;

  //Http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  //Http header Type
  //Form url encoded format header
  static const Map<String, dynamic> HEADER_URL_ENCODED = {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
  };

  //Json format header, if you change 'dio' to other http request library
  // please make sure this will be default setting which is as same as dio
  static const Map<String, dynamic> HEADER_JSON = {
    "Accept": "application/json",
    "Content-Type": "application/json; charset=UTF-8",
  };

  //Json format header, if you change 'dio' to other http request library
  // please make sure this will be default setting which is as same as dio
  static const Map<String, dynamic> HEADER_GZIP = {
    "Accept": "application/json",
    "Content-Encoding": "gzip",
  };
  //ContentType
  static const String  CONTENT_TYPE_JSON= Headers.jsonContentType;
  static const String  CONTENT_TYPE_FROM_URL_ENCODED= Headers.formUrlEncodedContentType;
  static const String  CONTENT_TYPE_TEXT_HTML= "text/html; charset=UTF-8";
  static const String  CONTENT_TYPE_TEXT_PLAIN= "text/plain; charset=UTF-8";
  static const String  CONTENT_TYPE_TEXT_XML= "text/xml; charset=UTF-8";
  static const String  CONTENT_TYPE_OCTET_STREAM= "application/octet-stream";
  static const String  CONTENT_TYPE_FORM_DATA= "multipart/form-data";

}
