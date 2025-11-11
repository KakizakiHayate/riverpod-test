import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';

/// Todo追加ダイアログを表示する関数
///
/// Riverpodの学習ポイント：
/// - StatelessWidgetからProviderにアクセスする方法
/// - [CREATE] 新しいTodoを追加する処理
void showAddTodoDialog(BuildContext context, WidgetRef ref) {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('新しいTodoを追加'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Todoのタイトル',
          border: OutlineInputBorder(),
          hintText: '例: 買い物に行く',
        ),
        autofocus: true,
        // Enterキーで追加できるようにする
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            ref.read(todoProvider.notifier).addTodo(value);
            Navigator.pop(context);
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              /// [CREATE] 新しいTodoを追加
              ///
              /// 学習ポイント：
              /// - ref.read()でnotifierにアクセスし、addTodoメソッドを呼び出す
              /// - これによりtodoProviderの状態が更新される
              /// - 状態の更新を監視しているすべてのウィジェットが自動的に再ビルドされる
              ref.read(todoProvider.notifier).addTodo(controller.text);
              Navigator.pop(context);
            }
          },
          child: const Text('追加'),
        ),
      ],
    ),
  );
}

/// FloatingActionButtonから呼び出すための簡易版
///
/// ConsumerWidgetでない画面から呼び出す場合は、
/// Consumer widgetでラップする必要があります
class AddTodoButton extends ConsumerWidget {
  const AddTodoButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => showAddTodoDialog(context, ref),
      child: const Icon(Icons.add),
    );
  }
}
