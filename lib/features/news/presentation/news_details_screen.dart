import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testovoe_news/core/utils/date_formatter.dart';
import '../data/models/article.dart';
import '../provider/detail_provider.dart';

class NewsDetailScreen extends ConsumerStatefulWidget {
  final Article article;
  final String username;

  const NewsDetailScreen(
      {super.key, required this.article, required this.username});

  @override
  ConsumerState<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends ConsumerState<NewsDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(detailProvider(widget.article.url!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: detailState.article.when(
        data: (article) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article?.urlToImage != null)
                  Image.network(article!.urlToImage!)
                else
                  const Placeholder(fallbackHeight: 200),
                const SizedBox(height: 16),
                Text(
                  article?.title ?? 'Нет заголовка',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(article?.description ?? 'Нет описания'),
                const SizedBox(height: 16),
                detailState.comments.when(
                  data: (comments) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Комментарии', style: TextStyle(fontSize: 18)),
                      ...comments.map((comment) => ListTile(
                            title: Text(comment.author),
                            subtitle: Text(
                              '${DateFormatter.formatDate(comment.createdAt)} — ${comment.text}',
                            ),
                          )),
                      TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                            labelText: 'Добавить комментарий'),
                        onSubmitted: (text) {
                          ref
                              .read(detailProvider(article!.url!).notifier)
                              .addComment(widget.username, text);
                          _commentController.clear();
                        },
                      ),
                    ],
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) =>
                      Center(child: Text('Ошибка загрузки комментариев')),
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Ошибка загрузки данных статьи')),
      ),
    );
  }
}
