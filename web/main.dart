import 'package:angular2/platform/browser.dart';
import 'package:redarx_ng_example/app_component.dart';


/*

/// RequestType » Command mapping
final requestMap = new Map<RequestType, CommandBuilder>()
  ..[RequestType.LOAD_ALL] = AsyncLoadAllCommand.builder
  ..[RequestType.ADD_TODO] = AddTodoCommand.constructor()
  ..[RequestType.UPDATE_TODO] = UpdateTodoCommand.constructor()
  ..[RequestType.CLEAR_ARCHIVES] = ClearArchivesCommand.constructor()
  ..[RequestType.COMPLETE_ALL] = CompleteAllCommand.constructor()
  ..[RequestType.TOGGLE_SHOW_COMPLETED] =
      ToggleShowArchivesCommand.constructor();


*/

main() {
  /*final cfg = new CommanderConfig<RequestType>(requestMap);

  final store =
      new Store<Command<TodoModel>, TodoModel>(() => new TodoModel.empty());
  final dispatcher = new Dispatcher();

  final cmder = new Commander<Command<TodoModel>, TodoModel>(
      cfg, store, dispatcher.onRequest);*/

  bootstrap(AppComponent );
}
