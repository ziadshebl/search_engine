import 'dart:convert';

import '../Constants/Endpoints.dart';
import 'package:http/http.dart' as http;

class WebServices {
  Future<List> searchWord(String word) async {
    try {
      final response = await http.get(
        EndPoints.baseUrl + word,
      );
      print(response.body);
      // if (response.statusCode != 201) {
      //   throw HTTPException(response.data['error']).toString();
      // }

      return jsonDecode(response.body) as List;
    } catch (e) {
      print(e);
      //throw HTTPException(e).toString();
    }
  }
}
