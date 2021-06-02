import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:search_engine/Constants/Colors.dart';
import 'package:search_engine/Models/WebsiteModel.dart';
import 'package:search_engine/Screens/HomeScreen.dart';
import 'package:search_engine/ViewModels/ResultsViewModel.dart';
import 'package:search_engine/ViewModels/SuggestionsViewModel.dart';
import 'package:search_engine/Widgets/ResultWidget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ResultsScreen extends StatefulWidget {
  static final routeName = '/resultsScreen';
  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  ResultsViewModel resultsViewModel;
  SuggestionsViewModel suggestionsViewModel;
  bool isSpeechAvailable = false;
  bool isRecognitionOn = false;
  stt.SpeechToText speech = stt.SpeechToText();
  TextEditingController searchController = TextEditingController();

  final PagingController<int, Website> _pagingController =
      PagingController(firstPageKey: 0);
  static const _pageSize = 3;
  SpeechRecognitionResult results;
  @override
  void initState() {
    resultsViewModel = Provider.of<ResultsViewModel>(context, listen: false);
    suggestionsViewModel =
        Provider.of<SuggestionsViewModel>(context, listen: false);
    searchController.text = resultsViewModel.word;
    Future.microtask(() async {
      print('INSIDE');
      try {
        if (!isSpeechAvailable) {
          isSpeechAvailable = await speech.initialize(
            onStatus: (status) {
              //print(status);
            },
            onError: (error) {
              print(error);
            },
          );
        }
      } catch (e) {
        print(e);
      }
    });

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (pageKey == null) return;
      final newItems = await resultsViewModel.searchWord(
          resultsViewModel.word, pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    resultsViewModel = Provider.of<ResultsViewModel>(context, listen: true);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: deviceSize.height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                          child: IconButton(
                              icon: Icon(Icons.menu), onPressed: () {})),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          resultsViewModel.word = '';
                          Navigator.pushReplacementNamed(
                              context, HomeScreen.routeName);
                        },
                        child: Container(
                          width: 100,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: RichText(
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              text: TextSpan(
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'D',
                                    style: TextStyle(
                                      color: ConstantColors.blue,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'O',
                                    style: TextStyle(color: ConstantColors.red),
                                  ),
                                  TextSpan(
                                    text: 'O',
                                    style:
                                        TextStyle(color: ConstantColors.yellow),
                                  ),
                                  TextSpan(
                                    text: 'D',
                                    style:
                                        TextStyle(color: ConstantColors.blue),
                                  ),
                                  TextSpan(
                                    text: 'L',
                                    style:
                                        TextStyle(color: ConstantColors.green),
                                  ),
                                  TextSpan(
                                    text: 'E',
                                    style: TextStyle(
                                      color: ConstantColors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: CircleAvatar(
                            minRadius: 15,
                            backgroundColor: Colors.blueGrey,
                            child: Text(
                              'Z',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 60,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: deviceSize.width * 0.6 < 500
                            ? deviceSize.width * 0.6
                            : 500,
                        child: TypeAheadField(
                          loadingBuilder: (BuildContext context) => Container(
                              height: 10,
                              width: 10,
                              child: CircularProgressIndicator()),
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: searchController,
                            style: TextStyle(fontSize: 20),
                            decoration: new InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 0.0),
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(30.0),
                                  ),
                                ),
                                filled: true,
                                prefixIcon: Icon(Icons.search),
                                suffix: searchController.text.isNotEmpty
                                    ? IconButton(
                                        alignment: Alignment.topCenter,
                                        iconSize: 20,
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.grey[500],
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            searchController.clear();
                                          });
                                        },
                                      )
                                    : null,
                                hintStyle:
                                    new TextStyle(color: Colors.grey[800]),
                                hintText: "",
                                fillColor: Colors.white70),
                          ),
                          suggestionsCallback: (pattern) async {
                            await suggestionsViewModel.getSuggesitons(pattern);
                            return suggestionsViewModel.suggestions;
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                              //subtitle: Text('\$${suggestion['price']}'),
                            );
                          },
                          onSuggestionSelected: (suggestion) async {
                            searchController.text = suggestion;
                            resultsViewModel.word = searchController.text;
                            FocusScope.of(context).unfocus();
                            _pagingController.refresh();
                          },
                        ),
                      ),
                      Container(
                        child: IconButton(
                          icon: Icon(isRecognitionOn
                              ? Icons.settings_voice_rounded
                              : Icons.keyboard_voice_rounded),
                          onPressed: () async {
                            print('HERE');
                            if (isRecognitionOn) {
                              setState(() {
                                if (results != null) {
                                  searchController.text =
                                      results.recognizedWords;
                                  isRecognitionOn = false;
                                  print('SET1');
                                }
                                isRecognitionOn = false;
                                speech.stop();
                              });
                            } else {
                              setState(() {
                                isRecognitionOn = true;

                                print('SET2');
                              });

                              speech.listen(onResult: (result) {
                                setState(() {
                                  results = result;
                                  print('SET3');
                                  print(result);
                                });
                              });
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        width: 80,
                        height: 40,
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  ConstantColors.blue),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                          color: ConstantColors.blue)))),
                          onPressed: () async {
                            resultsViewModel.word = searchController.text;
                            FocusScope.of(context).unfocus();
                            _pagingController.refresh();
                          },
                          child: Text(
                            'Search',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: deviceSize.height - 205,
                  color: Colors.grey[200],
                  child: PagedListView<int, Website>(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Website>(
                      itemBuilder: (context, item, index) => ResultWidget(
                        url: item.url,
                      ),
                    ),
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
