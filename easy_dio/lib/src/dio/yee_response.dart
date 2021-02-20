//Author: J_X
//Date: 2019-12-09
//Description: yee_response
part of '../../easy_dio.dart';

class YeeResponse {
  Response _response;
  String _builderID;

  String builderID() {
    return this._builderID;
  }

  YeeResponse(Response response, {String id}) {
    this._response = response;
    this._builderID =  id;
  }

  String getHeader() {
    return this._response?.headers.toString();
  }

  // Response body. may have been transformed, please refer to [YeeResponseType].
  dynamic getData() {
    return this._response?.data;
  }

  YeeRequestOption getRequest() {
    if (this._response != null) {
      return YeeRequestOption(this._response.request);
    }
    return null;
  }

  getStatusCode() {
    return this._response?.statusCode;
  }

  getStatusMessage() {
    return this._response?.statusMessage;
  }

  Map<String, dynamic> getExtra() {
    return this._response?.extra;
  }

  @override
  String toString() {
    if (this._response.data is Map) {
      return json.encode(this._response.data);
    }
    return this._response.data.toString();
  }
}
