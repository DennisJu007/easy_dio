# easy_dio
 Dio-based client generator.
# [Usage] asyncRequest:

 ## 1. Implement OnRequestCallBack
```
class _MyHomePageState extends State<MyHomePage> implements OnRequestCallBack
  @override
  dynamic onPreRequest(YeeRequestOption request);
  @override
  void onError(YeeDioError e) {}
  @override
  void onResponse(YeeResponse result) {}
```
## 2.How to crate a asyncRequest builder
```
YeeHttpBuilder _yeeHttpBuilder = new YeeHttpBuilder(context: this)
 .baseUrl("https://jsonplaceholder.typicode.com/posts")
 .method(HttpConfigs.GET)
 .build();
```
 NOTE: if params is form-urlencoded please set this.formDataParams(true)

## 3.To async request the jsonToBean object（type:dynamic）
``` _yeeHttpBuilder.asyncRequest();```

## 4.Destroy builder while widget will be in background, Every builder has itself cancelToken
``` _yeeHttpBuilder.cancelToken(true);```


# [Usage] syncRequest:

## 1.How to crate a syncRequest builder
```
YeeHttpBuilder _yeeHttpBuilder = new YeeHttpBuilder()
 .baseUrl("https://jsonplaceholder.typicode.com/posts")
 .method(HttpConfigs.GET)
 .build();
```
## 2.To sync receive the jsonToBean object（type:dynamic）

 ```dynamic response = await _yeeHttpBuilder.syncRequest();```

# [Usage] Download:

 ## 1.Tips: While file's size more than 5MB, we recommend using downloadLargeFile to increase download speed , another side we use downloadSmallFile
```
 YeeHttpBuilder builder = new YeeHttpBuilder(ignoreDefaultHttpConfig: true)
 .method(HttpConfigs.GET)
 .baseUrl(urlLarge)
 .log(true)
 .build();
```
 ## 2.Demo
 ```
dynamic result = await builder.downloadLargeFile(
 "[your save path]", onReceiveProgress: (received, total) async{
if (total != -1) {
 print("progress:" + (received / total * 100).toStringAsFixed(0) + "%");
 }
 });
```
# [Usage] CacheInterceptor

## 1.Tips: There's always some data we don't need it in real time so we can ask for it from http cache
 ```
YeeHttpBuilder builder = new YeeHttpBuilder()
 .method(HttpConfigs.GET)
 .baseUrl(urlWeb)
 .addInterceptor(CacheInterceptor())
 .log(true)
 .build();
```
## 2.Demo
```
 await builder.syncRequest(); //first request form Intent
 await builder.syncRequest(); //second request form our local cache
 builder.forceRefreshCache(true);//ignore local cache， ask for data from Intent
 await builder.syncRequest();//third request form Intent again
```
# [Usage] Verify Https Certificate:
### 1.Custom your certificate by setting pem string with YeeHttpBuilder.httpsCertificate(certificate)

### 2.【Not Recommending】Ignore verify by setting YeeHttpBuilder.verifyHttpsCertificate(false), default value{true}.

```
YeeHttpBuilder builder = new YeeHttpBuilder()
 .method(HttpConfigs.GET)
 .baseUrl(urlJson)
 .log(true)
 .httpsCertificate("your pem string") //custom https certificate which format is pem
/// .verifyHttpsCertificate(false) //ignore https verify, Not Recommend!!!
 .build();
```
#  [Usage] Params Type: Map(default)\FormData
```
1.Map<String, dynamic>
2.YeeHttpBuilder.formDataParams(true) transform Map to FormData
```

# [Usage] Track Request: You can set one more id(.id("xxx)) for every YeeHttpBuilder instance to mark every network request
## 1. if not we support default id for you {@link _createDefaultUniqueKey()}
## 2. Demo 
```
YeeHttpBuilder _yeeHttpBuilder = new YeeHttpBuilder()
 .baseUrl("https://jsonplaceholder.typicode.com/posts")
 .method(HttpConfigs.GET)
 .id("your mark")
 .build();
```
## 3.you can track "your mark" in {@link OnRequestCallBack}method like:
 ```
@override
 void onResponse(YeeResponse response) {
 print("YeeHttpBuilderUtil_onResponse:");
 if (response.builderID() == "your mark") {
 //TODO your deal
 }
 if (response.builderID() == "another mark") {
 //TODO your deal
 }
 }
```
