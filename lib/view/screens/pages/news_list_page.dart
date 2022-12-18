import 'package:flutter/material.dart';
import 'package:news_feed/data/category_info.dart';
import 'package:news_feed/data/search_type.dart';
import 'package:news_feed/models/model/news_model.dart';
import 'package:news_feed/view/components/article_tile.dart';
import 'package:news_feed/view/components/category_chips.dart';
import 'package:news_feed/view/components/search_bar.dart';
import 'package:news_feed/view/screens/news_web_page_screen.dart';
import 'package:news_feed/view_models/news_list_viewmodel.dart';
import 'package:provider/provider.dart';

class NewsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<NewsListViewModel>();
    final primaryColor = Theme.of(context).primaryColor;

    if (!viewModel.isLoading && viewModel.articles.isEmpty) {
      Future(() => viewModel.getNews(
          searchType: SearchType.CATEGORY, category: categories[0]));
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          tooltip: "更新",
          onPressed: () => onRefresh(context),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            //検索ワード
            SearchBar(onSearch: (keyWord) => getKeywordNews(context, keyWord)),
            //カテゴリー選択Chips
            CategoryChips(
                onCategorySelected: (category) =>
                    getCategoryNews(context, category)),
            //記事表示
            //更新ボタン
            Expanded(child: Consumer<NewsListViewModel>(
              builder: (context, model, child) {
                return model.isLoading
                    ? Center(child: CircularProgressIndicator(color: primaryColor))
                    : ListView.builder(
                        itemCount: model.articles.length,
                        itemBuilder: (context, int position) => ArticleTile(
                              article: model.articles[position],
                              onArticleClicked: (article) =>
                                  _openArticleWebPage(article, context),
                            ));
              },
            )),
          ]),
        ),
      ),
    );
  }

  //記事更新処理
  Future<void> onRefresh(BuildContext context) async {
    final viewModel = context.read<NewsListViewModel>();
    await viewModel.getNews(
        searchType: viewModel.searchType,
        keyword: viewModel.keyword,
        category: viewModel.category);
  }

  //キーワード記事取得処理
  Future<void> getKeywordNews(BuildContext context, keyWord) async {
    final viewModel = context.read<NewsListViewModel>();
    await viewModel.getNews(
        searchType: SearchType.KEYWORD,
        keyword: keyWord,
        category: categories[0]);
  }

  //カテゴリー記事取得処理
  Future<void> getCategoryNews(BuildContext context, Category category) async {
    final viewModel = context.read<NewsListViewModel>();
    await viewModel.getNews(
        searchType: SearchType.CATEGORY, category: category);
    print("NewsListPage.getCategoryNews / category : ${category.nameJp}");
  }

  _openArticleWebPage(Article article, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsWebPageScreen(article: article)));
  }
}
