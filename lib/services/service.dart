import 'dart:convert';

import 'package:banking/models/model.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

///https://622ac4ea14ccb950d224c9cb.mockapi.io/api/:endpoint

class Network {
  static bool isTester = true;

  static String SERVER_DEVELOPMENT = "622ac4ea14ccb950d224c9cb.mockapi.io";
  static String SERVER_PRODUCTION = "622ac4ea14ccb950d224c9cb.mockapi.io";

  static Map<String, String> getHeaders() {
    Map<String, String> headers = {
       'Content-Type': 'application/json',
      // 'x-api-key': '9f4995f9-b677-472e-838a-9a3f0b17dfa2'
    };
    return headers;
  }

  static Map<String, String> getUploadHeaders() {
    Map<String, String> headers = {
      //'Content-Type': 'multipart/form-data',
      //'x-api-key': '9f4995f9-b677-472e-838a-9a3f0b17dfa2'
    };
    return headers;
  }

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  /* Http Requests */

  static Future<String?> GET(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await get(uri, headers: getHeaders());
    if (response.statusCode == 200) return response.body;
    return null;
  }
  static Future<String?> POST(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api); // http or https
    var response = await post(uri, headers: getHeaders(), body: jsonEncode(params));

    if (response.statusCode == 200 || response.statusCode == 201) return response.body;
    return null;
  }

  static Future<String?> MULTIPART(String api, String filePath, Map<String, String> body) async {
    var uri = Uri.https(getServer(), api);
    var request = MultipartRequest('POST', uri);
    request.headers.addAll(getUploadHeaders());
    request.files.add(await MultipartFile.fromPath('file', filePath, contentType: MediaType("image", "jpeg")));
    request.fields.addAll(body);
    StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return await response.stream.bytesToString();
    } else {
      return response.reasonPhrase;
    }
  }

  static Future<String?> DELETE(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await delete(uri, headers: getUploadHeaders());
    if (response.statusCode == 200) return response.body;
    return null;
  }

  /* Http Apis */
  static String API_LIST = "/bankapp";
  static String API_ID = "/bankapp/";//{id}

  /* Http Body */
  static Map<String, String> paramsDelete(String id) {
    Map<String, String> body = {'id': id};
    return body;
  }

  /* Http Params */
  static Map<String, String> paramsEmpty() {
    Map<String, String> params = {};
    return params;
  }

  static Map<String, dynamic> paramsPage(int pageNumber) {
    Map<String, String> params = {};
    params.addAll({'limit': '25', 'page': pageNumber.toString()});
    return params;
  }

  static Map<String, String> paramsAdd(BankApp body) {
    Map<String, String> params = {};
    params.addAll(
        {'id': body.id.toString(),
        'username': body.username.toString(),
        'svv': body.svv.toString(),
        'cardnumber': body.cardnumber.toString(),
        'date': body.date.toString(),}
    );
    return params;
  }

  static Map<String, dynamic> paramsBreedSearch(String search) {
    Map<String, String> params = {};
    params.addAll({'q': search});
    return params;
  }

  /* Http parsing */
  static List<BankApp> parseResponse(String response) {
    List json = jsonDecode(response);
    List<BankApp> photos = List<BankApp>.from(json.map((x) => BankApp.fromJson(x)));
    return photos;
  }

}