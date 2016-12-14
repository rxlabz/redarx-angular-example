import 'dart:async';

import 'package:angular2/core.dart';
import 'package:redarx/redarx.dart';
import 'package:redarx_ng_example/state/commands.dart';
import 'package:redarx_ng_example/state/model.dart';

const CFG_COMMANDER = const OpaqueToken('cfg.commands');

const DATA_PATH = "todos.json";

final Map<RequestType, CommandBuilder> requestMap = {
  RequestType.LOAD_ALL: AsyncLoadAllCommand.constructor(DATA_PATH),
  RequestType.ADD_TODO: AddTodoCommand.constructor(),
  RequestType.UPDATE_TODO: UpdateTodoCommand.constructor(),
  RequestType.CLEAR_ARCHIVES: ClearArchivesCommand.constructor(),
  RequestType.COMPLETE_ALL: CompleteAllCommand.constructor(),
  RequestType.TOGGLE_SHOW_COMPLETED: ToggleShowArchivesCommand.constructor()
};

CommanderConfig<RequestType> configFactory() {
  return new CommanderConfig<RequestType>(requestMap);
}

const DEFAULT_STORE = const OpaqueToken('redarx.store.default');
Store<Command<TodoModel>, TodoModel> storeFactory() =>
    new Store<Command<TodoModel>, TodoModel>(() => const TodoModel.empty());


/// dispatcher unique  - pseu
final dispatcher = new Dispatcher();

const DISPATCH = const OpaqueToken('redarx.dispatch');
Dispatch dispatchFactory() => dispatcher.dispatch;

const REQUEST$ = const OpaqueToken('redarx.request\$');
Stream<Request> request$Factory() => dispatcher.request$;

