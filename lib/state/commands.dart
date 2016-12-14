import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:redarx/redarx.dart';
import 'package:redarx_ng_example/state/model.dart';

enum RequestType {
  ADD_TODO,
  UPDATE_TODO,
  CLEAR_ARCHIVES,
  TOGGLE_SHOW_COMPLETED,
  COMPLETE_ALL,
  LOAD_ALL
}

const String PATH = "todos.json";

/// async json loader
class AsyncLoadAllCommand extends AsyncCommand<TodoModel> {
  String path;

  TodoModel _lastState;

  TodoModel get lastState => _lastState;

  AsyncLoadAllCommand(this.path);

  @override
  Future<TodoModel> execAsync(TodoModel model) async {
    List<Todo> items = await loadAll();
    _lastState = model;
    return new TodoModel(items, model.showCompleted);
  }

  Future<List<Todo>> loadAll() async {
    var data = await HttpRequest.getString('todos.json');
    return (JSON.decode(data)['todos'] as List<dynamic>)
        .map((d) => new Todo.fromMap(d))
        .toList();
  }

  /*static AsyncLoadAllCommand build (t) => new AsyncLoadAllCommand(PATH);

  static const AsyncCommandBuilder builder = build;*/

  static AsyncCommandBuilder constructor(String path) {
    return (t) => new AsyncLoadAllCommand(path);
  }
}

/// add a new task
class AddTodoCommand extends Command<TodoModel> {
  Todo todo;

  AddTodoCommand(this.todo);

  @override
  TodoModel exec(TodoModel model) => model..items.add(todo);

  static CommandBuilder constructor() {
    return (Todo todo) => new AddTodoCommand(todo);
  }
}

/// change task state
class UpdateTodoCommand extends Command<TodoModel> {
  Todo todo;

  UpdateTodoCommand(this.todo);

  @override
  TodoModel exec(TodoModel model) {
    final updated = model.items.singleWhere((t) => t.uid == todo.uid);
    final updatedIndex = model.items.indexOf(updated);
    return model..items.replaceRange(updatedIndex, updatedIndex + 1, [todo]);
  }

  static CommandBuilder constructor() {
    return (Todo todo) => new UpdateTodoCommand(todo);
  }
}

/// remove completed tasks from archives
class ClearArchivesCommand extends Command<TodoModel> {
  @override
  TodoModel exec(TodoModel model) => new TodoModel(
      model.items.where((t) => !t.completed).toList(), model.showCompleted);

  static CommandBuilder constructor() {
    return (t) => new ClearArchivesCommand();
  }
}

/// complete all tasks
class CompleteAllCommand extends Command<TodoModel> {
  @override
  TodoModel exec(TodoModel model) => new TodoModel(
      model.items.map((item) {
        item.completed = true;
        return item;
      }).toList(),
      model.showCompleted);

  static CommandBuilder constructor() {
    return (t) => new CompleteAllCommand();
  }
}

/// toggle view remaining | completed
class ToggleShowArchivesCommand extends Command<TodoModel> {
  @override
  TodoModel exec(TodoModel model) =>
      new TodoModel(model.items, !model.showCompleted);

  static CommandBuilder constructor() {
    return (t) => new ToggleShowArchivesCommand();
  }
}
