part of '../../easy_dio.dart';
//common http request cacheInterceptor @link{YeeHttpBuilder.addInterceptor(CacheInterceptor())} @link{YeeHttpBuilder.forceRefreshCache}
class CacheInterceptor extends Interceptor {
  static const String EXTRA_REFRESH_KEY = 'refresh_cache';

  CacheInterceptor();

  var _cache = Map<Uri, Response>();

  @override
  Future onRequest(RequestOptions options) async {
    Response response = _cache[options.uri];
    if (options.extra[EXTRA_REFRESH_KEY] == true) {
      return options;
    } else if (response != null) {
      return response;
    }
  }

  @override
  Future onResponse(Response response) async {
    _cache[response.request.uri] = response;
  }

  @override
  Future onError(Exception err) async {
//    print('CacheInterceptor onError: $err');
  }
}

class CookieInterceptor {
  createInterceptor(String cookiePath) {
    return CookieManager(PersistCookieJar(dir: cookiePath));
  }
}

