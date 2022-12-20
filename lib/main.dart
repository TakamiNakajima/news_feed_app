import 'package:flutter/material.dart';
import 'package:news_feed/di/providers.dart';
import 'package:news_feed/models/db/database.dart';
import 'package:news_feed/view/screens/home_screen.dart';
import 'package:news_feed/view/screens/pages/head_line_page.dart';
import 'package:news_feed/view/style/style.dart';
import 'package:news_feed/view_models/head_line_viewmodel.dart';
import 'package:news_feed/view_models/news_list_viewmodel.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MultiProvider(
    providers: globalProviders,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NewsFeed",
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: BoldFont,
      ),
      home: HomeScreen(),
    );
  }
}
