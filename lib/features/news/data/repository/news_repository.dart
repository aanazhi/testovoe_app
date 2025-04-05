import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:testovoe_news/core/utils/constants.dart';
import '../models/article.dart';

class NewsRepository {
  final Dio dio;
  final Box<Article> articleBox;

  NewsRepository({required this.dio, required this.articleBox});

  Future<List<Article>> fetchNewsFromApi(String query) async {
    final response = await dio.get('/everything', queryParameters: {
      'q': query,
      'apiKey': Constants.apiKey,
    });

    if (response.statusCode == 200) {
      final List<dynamic> articlesJson = response.data['articles'];
      final List<Article> articles =
          articlesJson.map((json) => Article.fromJson(json)).toList();

      for (var article in articles) {
        if (!articleBox.values
            .any((existingArticle) => existingArticle.url == article.url)) {
          articleBox.put(article.url, article);
        }
      }

      return articles;
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<List<Article>> searchArticlesLocally(String query) async {
    final articles = articleBox.values.toList();
    return articles
        .where((article) =>
            article.title!.toLowerCase().contains(query.toLowerCase()) ||
            (article.description?.toLowerCase().contains(query.toLowerCase()) ??
                false))
        .toList();
  }
}
