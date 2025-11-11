import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_item.dart';
import '../widgets/add_todo_dialog.dart';

/// Todoリスト画面
///
/// Riverpodの学習ポイント：
/// - ConsumerWidgetでProviderの状態を監視
/// - ref.watch()で状態の変更を自動的に検知
/// - フィルター機能による派生状態の活用
class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// [READ] フィルター済みのTodoリストを取得
    ///
    /// 学習ポイント：
    /// - ref.watch()で監視することで、Todoリストが変更されると自動的に再ビルド
    /// - filteredTodosProviderは複数のProviderを組み合わせた派生Provider
    final todos = ref.watch(filteredTodosProvider);

    /// 未完了のTodo数を取得
    final uncompletedCount = ref.watch(uncompletedTodoCountProvider);

    /// 現在のフィルター状態を取得
    final currentFilter = ref.watch(todoFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod TODO アプリ'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          /// 完了済みTodoをすべて削除するボタン
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: '完了済みを削除',
            onPressed: () {
              ref.read(todoProvider.notifier).clearCompleted();
            },
          ),
        ],
      ),

      body: Column(
        children: [
          /// フィルターボタン
          _buildFilterButtons(ref, currentFilter),

          /// 統計情報
          _buildStats(uncompletedCount, todos.length),

          /// Todoリスト
          Expanded(
            child: todos.isEmpty
                ? _buildEmptyState(currentFilter)
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return TodoItem(todo: todo);
                    },
                  ),
          ),
        ],
      ),

      /// [CREATE] 新しいTodoを追加するボタン
      floatingActionButton: const AddTodoButton(),
    );
  }

  /// フィルターボタンを構築
  Widget _buildFilterButtons(WidgetRef ref, TodoFilter currentFilter) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterChip(
            ref,
            label: 'すべて',
            filter: TodoFilter.all,
            isSelected: currentFilter == TodoFilter.all,
          ),
          _buildFilterChip(
            ref,
            label: '未完了',
            filter: TodoFilter.active,
            isSelected: currentFilter == TodoFilter.active,
          ),
          _buildFilterChip(
            ref,
            label: '完了済み',
            filter: TodoFilter.completed,
            isSelected: currentFilter == TodoFilter.completed,
          ),
        ],
      ),
    );
  }

  /// 個別のフィルターチップを構築
  Widget _buildFilterChip(
    WidgetRef ref, {
    required String label,
    required TodoFilter filter,
    required bool isSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        /// フィルター状態を更新
        ///
        /// 学習ポイント：
        /// - StateProviderの値を直接更新
        /// - ref.read().state = で値を設定
        ref.read(todoFilterProvider.notifier).state = filter;
      },
    );
  }

  /// 統計情報を表示
  Widget _buildStats(int uncompletedCount, int totalCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '未完了: $uncompletedCount件',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '合計: $totalCount件',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// 空の状態を表示
  Widget _buildEmptyState(TodoFilter filter) {
    String message;
    IconData icon;

    switch (filter) {
      case TodoFilter.active:
        message = '未完了のTodoはありません\n素晴らしい！';
        icon = Icons.check_circle_outline;
        break;
      case TodoFilter.completed:
        message = '完了したTodoはありません\nまだTodoを追加していないか、\nすべて削除されています';
        icon = Icons.inbox_outlined;
        break;
      case TodoFilter.all:
      default:
        message = 'Todoがありません\n右下のボタンから追加してください';
        icon = Icons.add_task;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
