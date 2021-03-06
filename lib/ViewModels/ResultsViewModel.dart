import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:search_engine/Constants/Status.dart';
import 'package:search_engine/Models/WebsiteModel.dart';
import 'package:search_engine/Services/WebServices.dart';
import 'package:search_engine/ViewModels/SuggestionsViewModel.dart';

class ResultsViewModel with ChangeNotifier {
  Status status = Status.success;
  List<Website> websites = [];
  String word = '';
  int pageKey = 0;
  int pageSize = 6;

  Future<List<Website>> searchWord(String word, bool newSearch) async {
    try {
      if (newSearch) {
        websites.clear();
        pageKey = 0;
      }
      this.word = word;
      status = Status.loading;
      notifyListeners();
      final results = await WebServices().searchWord(word, pageKey, pageSize);

      for (int i = 0; i < results.length; i++) {
        Website website = Website.fromJson(results[i]);
        print(results[i]);
        websites.add(website);
      }

      status = Status.success;
      pageKey++;
      notifyListeners();
      return websites;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
