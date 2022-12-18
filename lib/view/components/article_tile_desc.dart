import 'package:flutter/material.dart';
import 'package:news_feed/models/model/news_model.dart';
import 'package:news_feed/view/style/style.dart';

class ArticleTileDesc extends StatelessWidget {
  final Article article;

  const ArticleTileDesc({required this.article});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(article.title ?? "",
            style: textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        Text(article.publishDate ?? "",
            style: textTheme.overline?.copyWith(fontStyle: FontStyle.italic)),
        const SizedBox(height: 8.0),
        Text(article.description ?? "",
            style: textTheme.bodyText2?.copyWith(fontFamily: RegularFont)),
      ],
    );
  }
}
