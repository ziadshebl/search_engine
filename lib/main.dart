import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:search_engine/Constants/Colors.dart';
import 'package:search_engine/Screens/HomeScreen.dart';
import 'package:search_engine/Screens/ResultsScreen.dart';
import 'package:search_engine/ViewModels/ResultsViewModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ResultsViewModel(),
        ),
        // ChangeNotifierProvider.value(
        //   value: AuthenticationViewModel(),
        // ),
        // ChangeNotifierProvider.value(
        //   value: ChannelsViewModel(),
        // ),
      ],
      child: MaterialApp(
        title: 'Doodle',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            accentColor: Colors.white,
            primaryColor: ConstantColors.blue,
            fontFamily: 'NotoSansJP'),
        home: HomeScreen(),
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          ResultsScreen.routeName: (ctx) => ResultsScreen(),
        },
      ),
    );
  }
}
