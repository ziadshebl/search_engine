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

  Future<bool> searchWord(String word) async {
    try {
      this.word = word;
      websites.clear();
      status = Status.loading;
      notifyListeners();
      final List results = await WebServices().searchWord(word);

      for (int i = 0; i < results.length; i++) {
        Website website = Website.fromJson(results[i]);
        print(results[i]);
        websites.add(website);
      }

      status = Status.success;
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
