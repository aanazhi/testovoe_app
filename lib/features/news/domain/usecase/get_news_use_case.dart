import 'package:testovoe_news/features/news/data/repository/news_repository.dart';
import 'package:testovoe_news/features/news/domain/entity/news_entity.dart';

class GetNewsUseCase {
  final NewsRepository newsRepository;

  GetNewsUseCase({required this.newsRepository});

  Future<List<NewsEntity>> execute(String query) async {
    final articles = await newsRepository.fetchNewsFromApi(query);
    return articles
        .map((article) => NewsEntity(
            title: article.title ?? 'Нет заголовка',
            description: article.description ?? 'Нет описания',
            urlToImage: article.urlToImage ??
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQekahu7VdTSKgxuaQbwrw1y4Xz23BPf5WvLg&s'))
        .toList();
  }
}
