/// Todoアイテムのデータモデル
///
/// Riverpodの学習ポイント：
/// - immutableなクラス設計（すべてのフィールドがfinal）
/// - copyWithメソッドでイミュータブルな更新を実現
class Todo {
  /// 一意なID（作成時のタイムスタンプを使用）
  final String id;

  /// Todoのタイトル
  final String title;

  /// 完了状態
  final bool isCompleted;

  const Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  /// イミュータブルなコピーを作成するメソッド
  ///
  /// Riverpodでは状態を直接変更せず、新しいオブジェクトを作成します
  /// これにより、状態の変更を追跡しやすくなります
  Todo copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// 完了状態を切り替える便利メソッド
  Todo toggleComplete() {
    return copyWith(isCompleted: !isCompleted);
  }

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, isCompleted: $isCompleted)';
  }
}
