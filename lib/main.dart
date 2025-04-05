import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:testovoe_news/features/auth/presentation/login_screen.dart';
import 'package:testovoe_news/features/auth/provider/auth_provider.dart';
import 'package:testovoe_news/features/news/data/models/article.dart';
import 'package:testovoe_news/features/news/data/models/comment.dart';
import 'package:testovoe_news/features/news/presentation/news_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());
  Hive.registerAdapter(CommentAdapter());

  await Hive.openBox<Article>('articles');
  await Hive.openBox<Comment>('comments');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: authState.isLoading
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : authState.isLoggedIn
              ? const NewsListScreen()
              : const LoginScreen(),
    );
  }
}
