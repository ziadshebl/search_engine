import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:search_engine/Models/WebsiteModel.dart';
import 'package:search_engine/Services/WebServices.dart';
import 'package:search_engine/ViewModels/ResultsViewModel.dart';
import 'package:search_engine/Widgets/ResultWidget.dart';

class CharacterSummary {
  CharacterSummary({
    @required this.id,
    @required this.name,
    @required this.pictureUrl,
  });

  factory CharacterSummary.fromJson(Map<String, dynamic> json) =>
      CharacterSummary(
        id: json['char_id'],
        name: json['name'],
        pictureUrl: json['img'],
      );

  final int id;
  final String name;
  final String pictureUrl;
}

class RemoteApi {
  static Future<List<CharacterSummary>> getCharacterList(
    int offset,
    int limit, {
    String searchTerm,
  }) async =>
      http
          .get(
            _ApiUrlBuilder.characterList(offset, limit, searchTerm: searchTerm),
          )
          .mapFromResponse<List<CharacterSummary>, List<dynamic>>(
            (jsonArray) => _parseItemListFromJsonArray(
              jsonArray,
              (jsonObject) => CharacterSummary.fromJson(jsonObject),
            ),
          );

  static List<T> _parseItemListFromJsonArray<T>(
    List<dynamic> jsonArray,
    T Function(dynamic object) mapper,
  ) =>
      jsonArray.map(mapper).toList();
}

//
class GenericHttpException implements Exception {}

class NoConnectionException implements Exception {}

class _ApiUrlBuilder {
  static const _baseUrl = 'https://www.breakingbadapi.com/api/';
  static const _charactersResource = 'characters/';

  static Uri characterList(
    int offset,
    int limit, {
    String searchTerm,
  }) =>
      Uri.parse(
        '$_baseUrl$_charactersResource?'
        'offset=$offset'
        '&limit=$limit'
        '${_buildSearchTermQuery(searchTerm)}',
      );

  static String _buildSearchTermQuery(String searchTerm) =>
      searchTerm != null && searchTerm.isNotEmpty
          ? '&name=${searchTerm.replaceAll(' ', '+').toLowerCase()}'
          : '';
}

extension on Future<http.Response> {
  Future<R> mapFromResponse<R, T>(R Function(T) jsonParser) async {
    try {
      final response = await this;
      if (response.statusCode == 200) {
        return jsonParser(jsonDecode(response.body));
      } else {
        throw GenericHttpException();
      }
    } on SocketException {
      throw NoConnectionException();
    }
  }
}

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => MaterialApp(
//         title: 'Infinite Scroll Pagination Sample',
//         theme: ThemeData(
//           primarySwatch: Colors.green,
//           buttonColor: Colors.green,
//         ),
//         home: CharacterListView(),
//       );
// }

class CharacterListView extends StatefulWidget {
  @override
  _CharacterListViewState createState() => _CharacterListViewState();
}

class _CharacterListViewState extends State<CharacterListView> {
  static const _pageSize = 20;

  final PagingController<int, Website> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      ResultsViewModel provider;
      provider = Provider.of<ResultsViewModel>(context, listen: false);
      final newItems =
          await provider.searchWord("barcelona", pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PagedListView<int, Website>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Website>(
            itemBuilder: (context, item, index) => ResultWidget(
              url: item.url,
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

/// List item representing a single Character with its photo and name.
class CharacterListItem extends StatelessWidget {
  const CharacterListItem({
    @required this.character,
    Key key,
  }) : super(key: key);

  final CharacterSummary character;

  @override
  Widget build(BuildContext context) => Text(character.name);
}

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("test"),
      ),
      //body: CharacterListView(),
    );
  }
}
