import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:search_engine/Constants/Status.dart';
import 'package:search_engine/Models/WebsiteModel.dart';
import 'package:search_engine/Services/WebServices.dart';

class SuggestionsViewModel with ChangeNotifier {
  Status status = Status.success;
  List<String> suggestions = [];

  Future<bool> getSuggesitons(String word) async {
    try {
      // status = Status.loading;
      // notifyListeners();
      print(word);
      final List results = await WebServices().getSuggestions(word);
      print(results);
      List<String> newSuggestions = [];
      for (int i = 0; i < results.length; i++) {
        String suggestion = results[i]['word'];
        print(results[i]);
        newSuggestions.add(suggestion);
      }
      if (word != '') {
        suggestions = newSuggestions;
      } else {
        suggestions = [];
      }

      print(suggestions);

      // status = Status.success;
      // notifyListeners();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
