import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

/// 個別のTodo項目を表示するウィジェット
///
/// Riverpodの学習ポイント：
/// - ConsumerWidgetを使ってProviderにアクセス
/// - ref.read()でProviderのメソッドを呼び出し（1回だけ読む）
/// - UIからProviderの状態を更新する方法を学ぶ
class TodoItem extends ConsumerWidget {
  final Todo todo;

  const TodoItem({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      /// [UPDATE] 完了状態をトグル
      ///
      /// 学習ポイント：
      /// - ref.read()でProviderのnotifierにアクセス
      /// - notifierのメソッドを呼び出して状態を更新
      leading: Checkbox(
        value: todo.isCompleted,
        onChanged: (value) {
          ref.read(todoProvider.notifier).toggleTodo(todo.id);
        },
      ),

      /// Todoのタイトルを表示（完了済みは打ち消し線）
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isCompleted
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          color: todo.isCompleted
              ? Colors.grey
              : null,
        ),
      ),

      /// 右端に削除ボタンとチェックアイコンを配置
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// 完了済みマーク
          if (todo.isCompleted)
            const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),

          const SizedBox(width: 8),

          /// [UPDATE] 編集ボタン
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () => _showEditDialog(context, ref),
          ),

          /// [DELETE] 削除ボタン
          ///
          /// 学習ポイント：
          /// - 削除も状態の更新として扱う
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            color: Colors.red,
            onPressed: () {
              ref.read(todoProvider.notifier).deleteTodo(todo.id);
            },
          ),
        ],
      ),
    );
  }

  /// Todo編集ダイアログを表示
  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: todo.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Todoを編集'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'タイトル',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(todoProvider.notifier).editTodo(
                      todo.id,
                      controller.text,
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
