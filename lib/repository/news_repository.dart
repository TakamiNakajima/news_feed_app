import 'dart:convert';

import 'package:news_feed/data/category_info.dart';
import 'package:http/http.dart' as http;
import 'package:news_feed/data/search_type.dart';
import 'package:news_feed/main.dart';
import 'package:news_feed/models/model/news_model.dart';
import 'package:news_feed/util/extentions.dart';

class NewsRepository {

  static const BASE_URL = "https://newsapi.org/v2/top-headlines?country=jp";
  static const API_KEY = "db86cf103d97471ca4d8784a046e0f1e";

  Future<List<Article>> getNews({required SearchType searchType, String? keyword, Category? category}) async {
    List<Article> results = [];
    http.Response? response;

    switch (searchType) {
      case SearchType.HEAD_LINE:
        final requestUrl = Uri.parse(BASE_URL + "&apiKey=$API_KEY");
        response = await http.get(requestUrl);
        break;
      case SearchType.KEYWORD:
        final requestUrl = Uri.parse(BASE_URL + "&q=$keyword&pageSize=30&apiKey=$API_KEY");
        response = await http.get(requestUrl);
        break;
      case SearchType.CATEGORY:
        final requestUrl = Uri.parse(BASE_URL + "&category=${category?.nameEn}&apiKey=$API_KEY");
        response = await http.get(requestUrl);
        break;
    }

    if (response.statusCode == 200) {
      //通常処理：受け取ったhttpステータスコードが200のときに実行
      final responseBody = response.body;
      //results = News.fromJson(jsonDecode(responseBody)).articles;
      results = await insertAndReadFromDB(jsonDecode(responseBody)) ;
    } else {
      //例外処理：受け取ったhttpステータスコードが200以外のときに実行
      throw Exception('Failed to load News');
    }
    return results;
  }

  Future<List<Article>> insertAndReadFromDB(responseBody) async{
    final dao = myDatabase.newsDao;
    final articles = News.fromJson(responseBody).articles;

    //Webから取得した記事リスト（Dartのモデルクラス：Article）をDBのテーブルクラス（Articles）に変換してDB登録・DBから取得
    final articleRecords = await dao.insertAndReadNewsFromDB(articles.toArticleRecords(articles));

    //DBから取得したデータをモデルクラスに再変換して返す
    return articleRecords.toArticles(articleRecords);
  }
}