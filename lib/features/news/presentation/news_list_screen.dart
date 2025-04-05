import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testovoe_news/features/news/presentation/news_details_screen.dart';
import 'package:testovoe_news/features/news/provider/detail_provider.dart';
import '../provider/news_provider.dart';

class NewsListScreen extends ConsumerStatefulWidget {
  const NewsListScreen({super.key});

  @override
  ConsumerState<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends ConsumerState<NewsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новости'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Поиск новостей',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) async {
                if (query.isEmpty) {
                  ref.read(newsProvider.notifier).updateQuery('technology');
                } else {
                  await ref
                      .read(newsProvider.notifier)
                      .searchNewsLocally(query);
                }
              },
            ),
          ),
          Expanded(
            child: newsState.when(
                data: (articles) => ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];

                        final detailState =
                            ref.watch(detailProvider(article.url!));
                        final commentsCount = detailState.comments.when(
                          data: (comments) => comments.length,
                          loading: () => 0,
                          error: (error, _) => 0,
                        );

                        return ListTile(
                          title: Text(article.title ?? 'Нет заголовка'),
                          subtitle: Text(article.description ?? 'Нет описания'),
                          trailing: Text('Комментариев: $commentsCount'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewsDetailScreen(article: article),
                              ),
                            );
                          },
                        );
                      },
                    ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text('Ошибка загрузки данных'))),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
