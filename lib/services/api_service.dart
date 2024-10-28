import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smart_solutions/constants/api_urls.dart';
import 'package:smart_solutions/constants/services.dart';

class ApiService {
  var header = {
    "x-api-key": APIUrls.apiKey,
  };
  // Method for GET requests
  Future<http.Response> getRequest(String endpoint) async {
    final response = await http.get(
      Uri.parse("${APIUrls.baseUrl}$endpoint"),
      headers: {
        "x-api-key": APIUrls.apiKey,
      },
    );
    return response;
  }

  // Method for POST requests
  Future<http.Response> postRequest(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("${APIUrls.baseUrl}/$endpoint"),
      headers: {
        "x-api-key": APIUrls.apiKey,
      },
      body: data,
    );
    logOutput("status code of $endpoint ${response.statusCode}");
    logOutput("response of $endpoint ${response.body}");
    return response;
  }

  // Method for Multipart POST requests (for file uploads)
  Future<dynamic> multipartPostRequest(String endpoint,
      Map<String, String> fields, File? file, String? fileFieldName) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("${APIUrls.baseUrl}/$endpoint"));
    request.headers.addAll(header);

    // Add fields
    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add file
    if (file != null) {
      var fileStream =
          await http.MultipartFile.fromPath(fileFieldName!, file.path);
      request.files.add(fileStream);
    }

    // Send request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print("response of $endpoint is ${response.body}");

    return response;
  }

  // Method for PUT requests

  Future<dynamic> putRequest(String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("${APIUrls.baseUrl}/$endpoint"),
      headers: {
        "Content-Type": "application/json",
        "x-api-key": "Surplus_apikey@",
      },
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // Method for DELETE requests
  Future<dynamic> deleteRequest(String endpoint) async {
    final response =
        await http.delete(Uri.parse("${APIUrls.baseUrl}/$endpoint"));
    return _handleResponse(response);
  }

  // Handle common response and errors
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      logOutput(response.body);
      return response.body;
    } else {
      throw Exception(
          "Error: ${response.statusCode}, Message: ${response.body}");
    }
  }
}
