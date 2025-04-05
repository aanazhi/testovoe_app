import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../data/models/article.dart';
import '../data/models/comment.dart';

final detailProvider =
    StateNotifierProvider.family<DetailNotifier, DetailState, String>(
        (ref, articleUrl) {
  final commentBox = Hive.box<Comment>('comments');
  return DetailNotifier(articleUrl, commentBox);
});

class DetailState {
  final AsyncValue<Article?> article;
  final AsyncValue<List<Comment>> comments;

  DetailState({
    required this.article,
    required this.comments,
  });

  DetailState copyWith({
    AsyncValue<Article?>? article,
    AsyncValue<List<Comment>>? comments,
  }) {
    return DetailState(
      article: article ?? this.article,
      comments: comments ?? this.comments,
    );
  }
}

class DetailNotifier extends StateNotifier<DetailState> {
  final String articleUrl;
  final Box<Comment> commentBox;

  DetailNotifier(this.articleUrl, this.commentBox)
      : super(DetailState(
          article: const AsyncValue.loading(),
          comments: const AsyncValue.loading(),
        )) {
    loadDetail(articleUrl);
  }

  Future<void> loadDetail(String articleUrl) async {
    state = state.copyWith(
      article: const AsyncValue.loading(),
      comments: const AsyncValue.loading(),
    );

    try {
      final articleBox = Hive.box<Article>('articles');
      final article =
          articleBox.values.firstWhere((element) => element.url == articleUrl);

      final comments = commentBox.values
          .where((comment) => comment.articleUrl == articleUrl)
          .toList();

      state = state.copyWith(
        article: AsyncValue.data(article),
        comments: AsyncValue.data(comments),
      );
    } catch (e, stackTrace) {
      state = state.copyWith(
        article: AsyncValue.error(e, stackTrace),
        comments: AsyncValue.error(e, stackTrace),
      );
    }
  }

  Future<void> addComment(String author, String text) async {
    try {
      final comment = Comment(
        articleUrl: articleUrl,
        author: author,
        text: text,
        createdAt: DateTime.now(),
      );

      commentBox.put(
          comment.articleUrl + DateTime.now().millisecondsSinceEpoch.toString(),
          comment);

      final updatedComments = List<Comment>.from(state.comments.value ?? [])
        ..add(comment);

      state = state.copyWith(comments: AsyncValue.data(updatedComments));
    } catch (e, stackTrace) {
      state = state.copyWith(comments: AsyncValue.error(e, stackTrace));
    }
  }
}
