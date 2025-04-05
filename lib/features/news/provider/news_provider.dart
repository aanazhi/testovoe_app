import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:testovoe_news/core/utils/constants.dart';
import '../data/repository/news_repository.dart';
import '../data/models/article.dart';

final newsProvider =
    AsyncNotifierProvider<NewsNotifier, List<Article>>(() => NewsNotifier());

class NewsNotifier extends AsyncNotifier<List<Article>> {
  late NewsRepository repository;
  String _query = 'technology';

  @override
  Future<List<Article>> build() async {
    final dio = Dio(BaseOptions(baseUrl: Constants.baseUrl));
    final articleBox = Hive.box<Article>('articles');
    repository = NewsRepository(dio: dio, articleBox: articleBox);
    return fetchNews(_query);
  }

  Future<List<Article>> fetchNews(String query) async {
    try {
      state = const AsyncValue.loading();
      final articles = await repository.fetchNewsFromApi(query);
      state = AsyncValue.data(articles);
      return articles;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  Future<void> searchNewsLocally(String query) async {
    try {
      state = const AsyncValue.loading();
      final articles = await repository.searchArticlesLocally(query);
      state = AsyncValue.data(articles);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void updateQuery(String query) {
    _query = query.isEmpty ? 'technology' : query;
    ref.invalidateSelf();
  }
}
