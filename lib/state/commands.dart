import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:built_collection/built_collection.dart';
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
    BuiltList<Todo> items = await loadAll();
    _lastState = model;
    return new TodoModel(new BuiltList<Todo>(items), model.showCompleted);
  }

  Future<BuiltList<Todo>> loadAll() async {
    var data = await HttpRequest.getString(path);
    return new BuiltList<Todo>((JSON.decode(data)['todos'] as List<dynamic>)
        .map((d) => new Todo.fromMap(d)));
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
  TodoModel exec(TodoModel model) => new TodoModel(
      model.items.rebuild((b) => b.add(todo)), model.showCompleted);

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
    var items = model.items
        .rebuild((b) => b.replaceRange(updatedIndex, updatedIndex + 1, [todo]));
    return new TodoModel(items, model.showCompleted);
  }

  static CommandBuilder constructor() {
    return (Todo todo) => new UpdateTodoCommand(todo);
  }
}

/// remove completed tasks from archives
class ClearArchivesCommand extends Command<TodoModel> {
  @override
  TodoModel exec(TodoModel model) => new TodoModel(
      model.items.rebuild((b) => b.where((t) => !t.completed)),
      model.showCompleted);

  static CommandBuilder constructor() {
    return (t) => new ClearArchivesCommand();
  }
}

/// complete all tasks
class CompleteAllCommand extends Command<TodoModel> {
  @override
  TodoModel exec(TodoModel model) => new TodoModel(
      model.items.rebuild((b) => b.map((item) => item..completed = true)),
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
