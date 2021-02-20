//Author: J_X
//Date: 2019-12-09
//Description: yee_dio_error

part of '../../easy_dio.dart';

enum YeeDioErrorType {
  /// It occurs when url is opened timeout.
  CONNECT_TIMEOUT,

  /// It occurs when url is sent timeout.
  SEND_TIMEOUT,

  ///It occurs when receiving timeout.
  RECEIVE_TIMEOUT,

  /// When the server response, but with a incorrect status, such as 404, 503...
  RESPONSE,

  /// When the request is cancelled, dio will throw a error with this type.
  CANCEL,

  /// Default error type, Some other Error. In this case, you can
  /// use the DioError.error if it is not null.
  DEFAULT,

  ///Connection Error like 401\xxx... catch by package connectivity: 0.4.6
  NETWORK_ERROR,
}

class YeeDioError implements Exception {
  DioError _error;
  String _builderID;
  YeeDioErrorType _errorType;

  String builderID() {
    return this._builderID;
  }

  YeeDioError(DioError e, {String id, YeeDioErrorType type}) {
    this._error = e;
    this._builderID = id;
    this._errorType = type;
  }

  YeeDioErrorType getErrorType() {
    if (this._errorType != null) {
      return this._errorType;
    }
    YeeDioErrorType type = YeeDioErrorType.DEFAULT;
    switch (this._error?.type) {
      case DioErrorType.CONNECT_TIMEOUT:
        type = YeeDioErrorType.CONNECT_TIMEOUT;
        break;
      case DioErrorType.SEND_TIMEOUT:
        type = YeeDioErrorType.SEND_TIMEOUT;
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        type = YeeDioErrorType.RECEIVE_TIMEOUT;
        break;
      case DioErrorType.RESPONSE:
        type = YeeDioErrorType.RESPONSE;
        break;
      case DioErrorType.CANCEL:
        type = YeeDioErrorType.CANCEL;
        break;
      case DioErrorType.DEFAULT:
        type = YeeDioErrorType.DEFAULT;
        break;
    }
    return type;
  }

  YeeResponse getResponse() {
    return this._error?.response != null
        ? YeeResponse(this._error.response)
        : null;
  }

  YeeRequestOption getRequestOption() {
    return this._error?.request != null
        ? YeeRequestOption(this._error.request)
        : null;
  }

  dynamic getError() {
    return this._error?.error;
  }

  String getMessage() {
    return this._error?.message;
  }

  String toString() {
    var msg = "YeeDioError [${this.getErrorType()}]: ${this._error?.message}";
    if (this._error?.error is Error) {
      msg += "\n${this._error.error.stackTrace}";
    }
    return msg;
  }
}
