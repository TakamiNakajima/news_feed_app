import 'package:drift/drift.dart';
import 'package:news_feed/models/db/database.dart';

part 'dao.g.dart';

@DriftAccessor(tables: [ArticleRecords])
class NewsDao extends DatabaseAccessor<MyDatabase> with _$NewsDaoMixin{
  NewsDao(MyDatabase db) : super(db);

  //データの削除
  Future clearDB() => delete(articleRecords).go();
  //データの入力
  Future insertDB(List<ArticleRecord> articles) async {
    await batch((batch) {
      batch.insertAll(articleRecords, articles);
    });
  }
  //読み込み
  Future<List<ArticleRecord>> get articlesFromDB => select(articleRecords).get();

  //削除 → 入力 → 読み込み
  Future<List<ArticleRecord>> insertAndReadNewsFromDB(List<ArticleRecord> articles) => transaction(() async{
    await clearDB();
    await insertDB(articles);
    return await articlesFromDB;
  });


}
