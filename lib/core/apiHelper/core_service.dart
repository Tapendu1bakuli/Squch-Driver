import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:squch_driver/core/apiHelper/app_exception.dart';
import 'package:mime/mime.dart';
import 'package:squch_driver/core/shared_pref/shared_pref.dart';
import '../utils/utils.dart';
import 'api_constant.dart';


class CoreService {
  Future apiService({
    GlobalKey? key,
    header,
    body,
    bool multiPart = false,
    params,
    METHOD? method,
    SSL ssl = SSL.HTTP,
    baseURL = BASE_URL,
    endpoint,
    filePath,
    String? fileKey,
    List<String>? fileKeys,
    attachmentList,
    nextFileKey,
    bool isLoader = true,
  }) async {
    SharedPref sharedPref = Get.find();
    String language = await sharedPref.getSelectedLanguage();
    var param;
    if (multiPart) {
      param = {
        'uploadType': params.toString(),
        "lang": language
      };
    }
    else {
      if(params!=null && params.isBlank){
        param = params;
        param["lang"] = language;
      }else{
        param = {
          "lang": language
        };
      }

    }
    var endPoint = endpoint;
    var uri;
    if (ssl == SSL.HTTP) {
      uri = Uri.http(Uri.encodeFull(baseURL), Uri.encodeFull(endPoint), param);
    } else {
      uri = Uri.https(Uri.encodeFull(baseURL), Uri.encodeFull(endPoint), param);
    }

    Map<String, String> requestHeaders = method == METHOD.MULTIPART
        ? {
      'Content-type': 'multipart/form-data',
    }
        : {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    if (header != null) {
      requestHeaders.addAll(header);
    }
    if (body != null && method != METHOD.MULTIPART) {
      body = json.encode(body);
    }
    debugPrint("Header :  $requestHeaders");
    debugPrint("Body :  $body");
    debugPrint("Params :  $param");
    debugPrint("URL :  $uri");
    debugPrint("Method :  $method");


    switch (method) {
      case METHOD.GET:
        {
          dynamic responseJson;
          try {
            final response = await http
                .get(uri, headers: requestHeaders)
                .timeout(const Duration(minutes: 2));
            responseJson = _returnResponse(response);
          } on UnauthorisedException catch (e) {
            Get.back();
            Get.showSnackbar(const GetSnackBar(
              snackPosition: SnackPosition.BOTTOM,
              message: "Token Expired. Login Again",
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
            ));
          }on IOException catch (e){
            showFailureSnackbar("No Internet", "Your device is not connected with internet.\n"+e.toString());
            return {"status":false,"message":"Your device is not connected with internet.\n"+e.toString()};
          } catch (error) {
            Get.back();
          }
          return responseJson;
        }


      case METHOD.POST:
        {
          dynamic responseJson;
          try {
            final response = await http
                .post(uri, headers: requestHeaders, body: body)
                .timeout(const Duration(minutes: 2));

            responseJson = _returnResponse(response);
          } on UnauthorisedException catch (e) {
        Get.showSnackbar(const GetSnackBar(
        snackPosition: SnackPosition.BOTTOM,
        message: "Token Expired. Login Again",
        duration: Duration(seconds: 2),
        margin: EdgeInsets.only(bottom: 20, left: 10, right: 10)));

        return {"status":false,"message":"Token Expired. Login Again"};
             /* await Get.deleteAll(force: true);
              await HiveStore().delete(Keys.accessToken);
              await HiveStore().delete(Keys.userName);
              await HiveStore().delete(Keys.userEmail);
              await HiveStore().delete(Keys.userRole);
              await HiveStore().delete(Keys.userCode);
              await HiveStore().delete(Keys.profileImage);
              await HiveStore().delete(Keys.ipAddress);
              await Get.offAllNamed(loginSeparate);*/
            }on IOException catch (e){
            showFailureSnackbar("No Internet", "Your device is not connected with internet.\n"+e.toString());
            return {"status":false,"message":"Your device is not connected with internet.\n"+e.toString()};
          }

          return responseJson;
        }

      case METHOD.MULTIPART:
        {
          dynamic responseJson;

          try {
            var request = http.MultipartRequest(
              'POST',
              uri,
            );
            if (header != null) {
              request.headers.addAll(header);
            }
            if (body != null) {
              request.fields.addAll(body);
            }
            if (filePath is RxList<File>) {
              List<http.MultipartFile> data = <http.MultipartFile>[];
              for (int i = 0; i < filePath.length; i++) {
                final mimeTypeData =
                    lookupMimeType(filePath[i].path, headerBytes: [0xFF, 0xD8])!
                        .split('/');
                data.add(await http.MultipartFile.fromPath(
                    '$fileKey[$i]', filePath[i].path,
                    contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
              }

              request.files.addAll(data);
            } else if (filePath is List<String>) {
              List<http.MultipartFile> data = <http.MultipartFile>[];
              for (int i = 0; i < filePath.length; i++) {
                final mimeTypeData =
                    lookupMimeType(filePath[i], headerBytes: [0xFF, 0xD8])!
                        .split('/');
                debugPrint("File Added : ${fileKeys![i]}, ${filePath[i]}");
                data.add(await http.MultipartFile.fromPath(
                    fileKeys[i], filePath[i],
                    contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
              }

              debugPrint("Attached Data length : ${data.length}");
              request.files.addAll(data);
            } else {
              //request.fields.addAll(body);
              final mimeTypeData =
                  lookupMimeType(filePath, headerBytes: [0xFF, 0xD8])!
                      .split('/');
              request.files.add(await http.MultipartFile.fromPath(
                  fileKey!, filePath,
                  contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
              debugPrint("Request : $request");
            }
            if (attachmentList != null && nextFileKey != null) {
              if (attachmentList is RxList<File>) {
                List<http.MultipartFile> data = <http.MultipartFile>[];
                for (int i = 0; i < filePath.length; i++) {
                  final mimeTypeData = lookupMimeType(filePath[i].path,
                          headerBytes: [0xFF, 0xD8])!
                      .split('/');
                  data.add(await http.MultipartFile.fromPath(
                      '$nextFileKey[$i]', attachmentList[i].path,
                      contentType:
                          MediaType(mimeTypeData[0], mimeTypeData[1])));
                }
                request.files.addAll(data);
              } else {
                final mimeTypeData =
                    lookupMimeType(filePath, headerBytes: [0xFF, 0xD8])!
                        .split('/');
                request.files.add(await http.MultipartFile.fromPath(
                    nextFileKey, attachmentList,
                    contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
                debugPrint("Request : $request");
              }
            }
            final http.StreamedResponse response = await request.send();
            debugPrint(response.reasonPhrase);
            responseJson = await http.Response.fromStream(response);
            responseJson = _returnResponse(responseJson);
          } catch (error) {
            debugPrint(error.toString());
            Get.back();
          }
          return responseJson;
        }

      default:
        {
          dynamic responseJson;
          try {
            Get.dialog(
                const Center(
                    child: CircularProgressIndicator(
                  color: Color(0xFFFF6F08),
                )),
                barrierDismissible: false);
            final response =
                await http.post(uri, headers: requestHeaders, body: body);
            responseJson = _returnResponse(response);
          } catch (error) {
            Get.back();
          }
          return responseJson;
        }
    }
  }

  dynamic _returnResponse(http.Response response) {
    debugPrint("response : $response");
    switch (response.statusCode) {
      case 200:
      case 201:
      case 422:
        var responseJson = json.decode(response.body);
        debugPrint("Result : $responseJson");
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<bool> networkCheck() async {
    try {
      final result = await InternetAddress.lookup(BASE_URL);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return false;
      } else {
        return true;
      }
    } on SocketException catch (_) {
      return true;
    }
  }

  Widget normalLoader() {
    return Center(
        child: Container(
            // height: MediaQuery.sizeOf(context).height,
            // width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(40))),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 1.5,
              ),
            )));
  }
}

enum METHOD {
  GET,
  POST,
  MULTIPART,
}

enum SSL {
  HTTP,
  HTTPS,
}
