import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:search_engine/Constants/Status.dart';
import 'package:search_engine/Models/WebsiteModel.dart';
import 'package:search_engine/Services/WebServices.dart';

class ResultsViewModel with ChangeNotifier {
  Status status = Status.success;
  List<Website> websites = [];
  TextEditingController _searchController = TextEditingController();

  TextEditingController get searchController {
    return _searchController;
  }

  Future<List<Website>> searchWord(
      String word, int pageKey, int pageSize) async {
    try {
      // websites.clear();
      status = Status.loading;
      notifyListeners();
      final results =
          await WebServices().searchWord("barcelona", pageKey, pageSize);

      for (int i = 0; i < results.length; i++) {
        Website website = Website.fromJson(results[i]);
        print(results[i]);
        websites.add(website);
      }

      status = Status.success;
      notifyListeners();
      return websites;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
