part of '../easy_dio.dart';

///interface for common setting
abstract class CommonSettingBuilder {
  //Request url
  CommonSettingBuilder baseUrl(String url);

  //Request sub url
  CommonSettingBuilder path(String path);

  //Request contentType
  CommonSettingBuilder contentType(String contentType);

  //Request contentType
  DioSettingBuilder responseType(YeeResponseType responseType);

  //Request params
  CommonSettingBuilder params(dynamic params);

  //Upload files
  CommonSettingBuilder files(Map<String, dynamic> files);

  //@Disable Request params formdata
  CommonSettingBuilder formDataParams(bool isFormData);

  //Request Method
  CommonSettingBuilder method(String method);

  // Timeout in milliseconds for opening  url.
  CommonSettingBuilder connectTimeout(int connectTimeout);

  //  Whenever more than [receiveTimeout] (in milliseconds) passes between two events from response stream,
  //  [easy_dio] will throw the [YeeDioError] with [YeeDioErrorType.RECEIVE_TIMEOUT].
  //  Note: This is not the receiving time limitation.
  CommonSettingBuilder receiveTimeout(int receiveTimeout);

  //Request Header
  CommonSettingBuilder header(Map<String, dynamic> header);

  //How to hide/show log
  CommonSettingBuilder log(bool hideLog);

  //request extra msg
  CommonSettingBuilder extra(Map<String, dynamic> extra);

  //request extra msg
  CommonSettingBuilder forceRefreshCache(bool force);

  //request https verify certificate
  CommonSettingBuilder httpsCertificate(String certificate);

  //request https verify certificate, if false can ignore verification,but if not necessary,not recommending ignore https's verification
  CommonSettingBuilder verifyHttpsCertificate(bool verify);

  //request unique id
  CommonSettingBuilder id(String uniqueId);
}
