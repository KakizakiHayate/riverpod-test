import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/todo_list_screen.dart';

/// アプリのエントリーポイント
///
/// Riverpodの学習ポイント：
/// - アプリ全体をProviderScopeでラップする必要がある
/// - ProviderScopeがすべてのProviderの状態を管理
void main() {
  runApp(
    /// ProviderScopeでアプリ全体をラップ
    ///
    /// 重要：Riverpodを使用するには必須
    /// これにより、アプリ内のすべてのウィジェットがProviderにアクセス可能になる
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// アプリのルートウィジェット
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod TODO アプリ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      /// TodoListScreenをホーム画面として設定
      home: const TodoListScreen(),
    );
  }
}
