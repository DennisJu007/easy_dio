part of '../../easy_dio.dart';

///interface for Dio setting not recommend to use this
///this is strong coupling with dio sdk which is not common logic
///if you make sure you can adapt your client code while we change dio to another network frame
abstract class DioSettingBuilder extends CommonSettingBuilder {
  //Custom interceptor
  DioSettingBuilder addInterceptor(Interceptor interceptor);
  //Fixed request status code 302
  DioSettingBuilder followRedirects(bool follow);
}
