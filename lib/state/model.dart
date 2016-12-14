import 'package:built_collection/built_collection.dart';
import 'package:redarx/redarx.dart';

class TodoModel extends AbstractModel{

  const TodoModel(this.items, this.showCompleted);

  final BuiltList<Todo> items;

  final bool showCompleted;

  BuiltList<Todo> get todos =>
      new BuiltList<Todo>(items.where((Todo t) => showCompleted ? t.completed : !t.completed));

  int get numCompleted => items.where((t)=>t.completed).length;

  int get numRemaining => items.where((t)=>!t.completed).length;

  TodoModel.empty():items = new BuiltList<Todo>(), showCompleted = false;

  @override
  AbstractModel initial() => new TodoModel.empty();

  @override
  String toString() {
    return '''
TodoModel{
  showCompleted = $showCompleted,
  todos : $todos
}
''';
  }
}

class Todo {
  int uid;
  String label;
  bool completed;

  Todo(this.label, [this.completed = false, this.uid = null]) {
    if (uid == null) uid = new DateTime.now().millisecondsSinceEpoch;
  }

  Todo.fromMap(Map<String, dynamic> data){
    this.uid = data['uid'];
    this.label = data['label'];
    this.completed = data['completed'] == 1;
  }

  @override
  String toString() {
    return 'Todo{ $uid , $label }';
  }
}
