import 'package:angular2/core.dart';
import 'package:redarx/redarx.dart';
import 'package:redarx_ng_example/commander-service.dart';
import 'package:redarx_ng_example/components/todo-footer.dart';
import 'package:redarx_ng_example/components/todo-form/todo-form.dart';
import 'package:redarx_ng_example/components/todo-item.dart';
import 'package:redarx_ng_example/config.dart';
import 'package:redarx_ng_example/state/commands.dart';
import 'package:redarx_ng_example/state/model.dart';

@Component(
    selector: 'my-app',
    styleUrls: const ['app_component.css'],
    templateUrl: 'app_component.html',
    viewProviders: const [
      const Provider(CFG_COMMANDER, useFactory: configFactory),
      const Provider(DEFAULT_STORE, useFactory: storeFactory),
      const Provider(DISPATCH, useFactory: dispatchFactory),
      const Provider(REQUEST$, useFactory: request$Factory),
      CommanderService
    ],
    directives: const [TodoForm, TodoFooter, TodoItem])
class AppComponent extends OnInit {
  TodoModel state;
  List<Todo> todos;

  Function dispatch;

  AppComponent(CommanderService commander, @Inject(DISPATCH) this.dispatch,
      @Inject(DEFAULT_STORE) Store<Command<TodoModel>, TodoModel> store) {
    store.state$.listen((TodoModel v) {
      state = v;
      todos = v.todos;
    } );
    loadAll();
  }

  @override
  ngOnInit() {}

  loadAll() {
    dispatch(new Request(RequestType.LOAD_ALL));
  }
  update(Todo todo) {
    print('AppComponent.update  todo ${todo}');
    dispatch(new Request(RequestType.UPDATE_TODO, withData: todo));
  }
}
