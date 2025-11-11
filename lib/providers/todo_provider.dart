import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';

/// TodoリストのStateNotifier
///
/// Riverpodの学習ポイント：
/// - StateNotifierを使って状態を管理
/// - stateは常にイミュータブルなリストとして扱う
/// - 各メソッドがCRUD操作を実装（Create, Read, Update, Delete）
class TodoNotifier extends StateNotifier<List<Todo>> {
  /// 初期状態として空のリストを設定
  TodoNotifier() : super([]);

  /// [CREATE] 新しいTodoを追加
  ///
  /// 学習ポイント：
  /// - state = [...state, newTodo] で新しいリストを作成
  /// - 既存のリストを直接変更せず、新しいリストを作成することが重要
  void addTodo(String title) {
    if (title.trim().isEmpty) return;

    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );

    // stateに新しいリストを代入することで、Riverpodが変更を検知
    state = [...state, newTodo];
  }

  /// [UPDATE] Todoの完了状態をトグル
  ///
  /// 学習ポイント：
  /// - map()で既存のTodoを探して、該当するものだけcopyWithで更新
  /// - toList()で新しいリストを作成
  void toggleTodo(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          todo.toggleComplete()
        else
          todo,
    ];
  }

  /// [UPDATE] Todoのタイトルを編集
  void editTodo(String id, String newTitle) {
    if (newTitle.trim().isEmpty) return;

    state = [
      for (final todo in state)
        if (todo.id == id)
          todo.copyWith(title: newTitle.trim())
        else
          todo,
    ];
  }

  /// [DELETE] Todoを削除
  ///
  /// 学習ポイント：
  /// - whereで該当するIDを除外した新しいリストを作成
  void deleteTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }

  /// [DELETE] 完了済みのTodoをすべて削除
  void clearCompleted() {
    state = state.where((todo) => !todo.isCompleted).toList();
  }
}

/// TodoNotifierのProvider
///
/// Riverpodの学習ポイント：
/// - StateNotifierProviderを使ってStateNotifierを公開
/// - このProviderを通じて、UIからTodoの状態にアクセス・更新できる
/// - ref.read()で読み取り、ref.watch()で変更を監視
final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});

/// フィルター用のEnum
enum TodoFilter {
  all,      // すべて
  active,   // 未完了のみ
  completed // 完了済みのみ
}

/// 現在のフィルター状態を管理するProvider
///
/// 学習ポイント：
/// - StateProviderは単純な値を管理する場合に使用
/// - TodoFilter.allが初期値
final todoFilterProvider = StateProvider<TodoFilter>((ref) {
  return TodoFilter.all;
});

/// フィルター済みのTodoリストを提供するProvider
///
/// Riverpodの学習ポイント：
/// - 複数のProviderを組み合わせて派生状態を作成
/// - ref.watch()で他のProviderの値を監視
/// - フィルターやソートロジックをUIから分離できる
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoProvider);
  final filter = ref.watch(todoFilterProvider);

  switch (filter) {
    case TodoFilter.active:
      return todos.where((todo) => !todo.isCompleted).toList();
    case TodoFilter.completed:
      return todos.where((todo) => todo.isCompleted).toList();
    case TodoFilter.all:
    default:
      return todos;
  }
});

/// 未完了のTodo数をカウントするProvider
///
/// 学習ポイント：
/// - Providerを使って計算済みの値を提供
/// - UIで直接カウントするのではなく、Providerで管理
final uncompletedTodoCountProvider = Provider<int>((ref) {
  final todos = ref.watch(todoProvider);
  return todos.where((todo) => !todo.isCompleted).length;
});
