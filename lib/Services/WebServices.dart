import 'dart:convert';

import 'package:search_engine/Models/WebsiteModel.dart';

import '../Constants/Endpoints.dart';
import 'package:http/http.dart' as http;

int req = 1;

class WebServices {
  Future<List<dynamic>> searchWord(
      String word, int pageNum, int pageSize) async {
    try {
      print(pageNum);
      req++;
      final response = await http.get(
        EndPoints.baseUrl +
            word +
            "?pageSize=" +
            pageSize.toString() +
            "&pageNum=" +
            pageNum.toString(),
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

  Future<List> getSuggestions(String word) async {
    try {
      final response = await http.get(
        EndPoints.baseUrl + '/getSuggestions/' + word,
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

//   Future<List<CharacterSummary>> getCharacterList(
//     int offset,
//     int limit, {
//     String searchTerm,
//   }) async =>
//       http
//           .get(
//             _ApiUrlBuilder.characterList(offset, limit, searchTerm: searchTerm),
//           )
//           .mapFromResponse<List<CharacterSummary>, List<dynamic>>(
//             (jsonArray) => _parseItemListFromJsonArray(
//               jsonArray,
//               (jsonObject) => CharacterSummary.fromJson(jsonObject),
//             ),
//           );

//   static List<T> _parseItemListFromJsonArray<T>(
//     List<dynamic> jsonArray,
//     T Function(dynamic object) mapper,
//   ) =>
//       jsonArray.map(mapper).toList();
// }

// class GenericHttpException implements Exception {}

// class NoConnectionException implements Exception {}

// class _ApiUrlBuilder {
//   static const _baseUrl = 'https://www.breakingbadapi.com/api/';
//   static const _charactersResource = 'characters/';

//   static Uri characterList(
//     int offset,
//     int limit, {
//     String searchTerm,
//   }) =>
//       Uri.parse(
//         '$_baseUrl$_charactersResource?'
//         'offset=$offset'
//         '&limit=$limit'
//         '${_buildSearchTermQuery(searchTerm)}',
//       );

//   static String _buildSearchTermQuery(String searchTerm) =>
//       searchTerm != null && searchTerm.isNotEmpty
//           ? '&name=${searchTerm.replaceAll(' ', '+').toLowerCase()}'
//           : '';
// }

// extension on Future<http.Response> {
//   Future<R> mapFromResponse<R, T>(R Function(T) jsonParser) async {
//     try {
//       final response = await this;
//       if (response.statusCode == 200) {
//         return jsonParser(jsonDecode(response.body));
//       } else {
//         throw GenericHttpException();
//       }
//     } on SocketException {
//       throw NoConnectionException();
//     }
//   }
// }
