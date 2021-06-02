import 'dart:convert';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:search_engine/Constants/Colors.dart';
import 'package:search_engine/Screens/ResultsScreen.dart';
import 'package:search_engine/ViewModels/ResultsViewModel.dart';
import 'package:search_engine/ViewModels/SuggestionsViewModel.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
//import 'package:raz3_ordering_form/Constants/Colors.dart';

class HomeScreen extends StatefulWidget {
  static final routeName = '/home-screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ResultsViewModel resultsViewModel;
  SuggestionsViewModel suggestionsViewModel;
  bool isSpeechAvailable = false;
  bool isRecognitionOn = false;
  stt.SpeechToText speech = stt.SpeechToText();
  TextEditingController searchController = TextEditingController();
  SpeechRecognitionResult results;

  @override
  void dispose() {
    resultsViewModel.removeListener(() {});
    super.dispose();
  }

  @override
  void initState() {
    resultsViewModel = Provider.of<ResultsViewModel>(context, listen: false);
    suggestionsViewModel =
        Provider.of<SuggestionsViewModel>(context, listen: false);
    Future.microtask(() async {
      print('INSIDE');
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
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: deviceSize.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Spacer(),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 10, 0),
                      child: TextButton(
                        child: Text(
                          'Home',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 15, 5, 0),
                        child: IconButton(
                            icon: Icon(Icons.apps_rounded), onPressed: () {})),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 20, 0),
                      child: CircleAvatar(
                          minRadius: 16,
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
                Spacer(
                  flex: 1,
                ),
                Container(
                  height: deviceSize.height * 0.15,
                  child: Image.asset('assets/hagras.png'),
                ),
                Container(
                  width: deviceSize.width * 0.6,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      text: TextSpan(
                        style: TextStyle(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: 'D',
                            style: TextStyle(
                                color: ConstantColors.blue, fontSize: 64),
                          ),
                          TextSpan(
                            text: 'O',
                            style: TextStyle(
                                color: ConstantColors.red, fontSize: 64),
                          ),
                          TextSpan(
                            text: 'O',
                            style: TextStyle(
                                color: ConstantColors.yellow, fontSize: 64),
                          ),
                          TextSpan(
                            text: 'D',
                            style: TextStyle(
                                color: ConstantColors.blue, fontSize: 64),
                          ),
                          TextSpan(
                            text: 'L',
                            style: TextStyle(
                                color: ConstantColors.green, fontSize: 64),
                          ),
                          TextSpan(
                            text: 'E',
                            style: TextStyle(
                              color: ConstantColors.red,
                              fontSize: 64,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
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
                              hintStyle: new TextStyle(color: Colors.grey[800]),
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
                          Navigator.pushReplacementNamed(
                              context, ResultsScreen.routeName);
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
                                searchController.text = results.recognizedWords;
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
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  width: 180,
                  height: 40,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(ConstantColors.blue),
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: ConstantColors.blue)))),
                    onPressed: () async {
                      resultsViewModel.word = searchController.text;
                      Navigator.pushReplacementNamed(
                          context, ResultsScreen.routeName);
                    },
                    child: Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
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
